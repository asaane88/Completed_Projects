import smtplib
import speech_recognition as sr
import pyttsx3
from email.message import EmailMessage

listener = sr.Recognizer
engine = pyttsx3.init()

def talk(text):
    engine.say(text)
    engine.runandWait()

def get_info():
    try:
        with sr.microphone() as source:
            print('Listening.....')
            voice = listener.listen(source)
            info = listener.recognize_google(voice)
            print(info)
            return info.lower()
    except:
        pass

def send_email(reciever, subject, message):
    #create a server
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls() # transfer layer security(tls)
    server.login('fresh.grandma21@gmail.com', 'GrandmaDatingSantaOnChristmas')
    email = EmailMessage()
    email['From'] = 'fresh.grandma21@gmail.com'
    email['To'] = reciever
    email['Subject'] = subject
    email.set_content(message)
    server.send_message(email)
    talk('Your Email is sent!!!')
    talk('Do you want to send more email?')
    send_more = get_info()
    if 'yes' in send_more:
        get_email_info()


email_list = {
    'dude': 'jhankar.mahbub2@gmail.com',
    'progamming': 'support@blakpink.com',
    'lisa': 'lisa@blackpink.com'
}

def get_email_info():
    talk('To Whom you want to send email')
    name = get_info()
    reciever = email_list[name]
    print(reciever)
    talk ('What is the subject of your email?')
    subject = get_info()
    talk('Tell me the text in your email')
    message = get_info()