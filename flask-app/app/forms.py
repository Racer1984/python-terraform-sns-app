from flask_wtf import FlaskForm
from wtforms import TextField
from wtforms.validators import Required


class SendForm(FlaskForm):
    msg = TextField('msg', validators=[Required()])
