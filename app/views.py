from flask import render_template, flash, redirect
from app import app
from .forms import SendForm
from .PySNS import create_client

@app.route('/')
def redir():
    return redirect('/index')

@app.route('/index', methods = ['GET', 'POST'])
def index():
    form = SendForm()
    if form.validate_on_submit():
        flash('You just sent "' + form.msg.data + '" to AWS SNS')
        sns = create_client()
        response = sns.publish(
            TopicArn = 'arn:aws:sns:us-east-2:591559526277:test-sns',
            Message = form.msg.data
        )
        return redirect('/index')
    return render_template('index.html', 
        title = 'Send Message to SNS',
        form = form)
