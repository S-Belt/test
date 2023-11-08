from flask import Flask, request, jsonify, render_template
from flask_mail import Mail, Message
import os
import logging

app = Flask(__name__)
app.config.update(
    DEBUG=True,
    MAIL_SERVER=os.environ.get('MAIL_SERVER'),
    MAIL_PORT=os.environ.get('MAIL_PORT'),
    MAIL_USE_TLS=os.environ.get('MAIL_USE_TLS'),
    MAIL_USE_SSL=os.environ.get('MAIL_USE_SSL'),
    MAIL_USERNAME=os.environ.get('MAIL_USER'),
    MAIL_PASSWORD=os.environ.get('MAIL_PASSWORD'),
)
mail = Mail(app)

# Configurez le logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

@app.route("/")
def index():
    logger.info("Index page")
    # log all env variables
    logger.info("All env variables: %s", os.environ)

    try:
        message = "Hello World"
        mail.send_message(subject="Hello from Flask-Mail",
                            body=message,
                            sender=app.config.get("MAIL_USERNAME"),
                            recipients=["leo.recouvreux@gmail.com"])
        return "Mail sent"
    except Exception as e:
        logger.error("Error sending email: %s", str(e))
        return str(e)


@app.route("/send_mail", methods=['POST'])
def reset_password():
    data = request.get_json(force=True, silent=True)
    logger.debug("Received data: %s", data)

    if not data or 'user' not in data:
        logger.error("Invalid data received")
        return jsonify({'error': 'Invalid data'}), 400

    user = data['user']
    for field in ['username', 'password', 'email']:
        if field not in user or not user[field]:
            logger.error("Missing or empty field in data: %s", field)
            return jsonify({'error': 'Invalid data, missing or empty field: {}'.format(field)}), 400

    try:
        msg = Message('Reset Password', sender='notreply@gotham.bat', recipients=[user['email']])
        msg.html = render_template('mail.html', username=user['username'], password=user['password'])
        mail.send(msg)
        logger.info("Email sent successfully to %s", user['email'])
        return jsonify({'message': 'Email sent'}), 200

    except Exception as e:
        logger.error("Failed to send email: %s", str(e))
        return jsonify({'error': 'Failed to send email'}), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
