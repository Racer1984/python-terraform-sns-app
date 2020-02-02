from flask import render_template, flash, redirect
from app import app
from .forms import SendForm
from .PySNS import create_clients


@app.route('/')
def redir():
    return redirect('/index')


@app.route('/index', methods=['GET', 'POST'])
def index():
    form = SendForm()
    if form.validate_on_submit():
        flash('You just sent "' + form.msg.data + '" to AWS SNS')
        sns, ssm = create_clients()
        sns.publish(TopicArn=ssm.get_parameter(Name='topic-arn', WithDecryption=False)['Parameter']['Value'], Message=form.msg.data)
        return redirect('/index')
    return render_template('index.html', title='Send Message to AWS SNS', form=form)
