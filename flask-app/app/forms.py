from flask_wtf import FlaskForm
from wtforms import TextField, BooleanField
from wtforms.validators import Required

class SendForm(FlaskForm):
    msg = TextField('msg', validators = [Required()])
