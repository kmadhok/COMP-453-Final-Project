from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from flask_login import current_user
from wtforms import StringField, PasswordField, SubmitField, BooleanField, TextAreaField, RadioField, IntegerField, DateField, SelectField, HiddenField
from wtforms.validators import DataRequired, Length, Email, EqualTo, ValidationError,Regexp
from wtforms.ext.sqlalchemy.fields import QuerySelectField
from flaskDemo import db
from flaskDemo.models import User
from wtforms.fields.html5 import DateField

#  or could have used ssns = db.session.query(Department.mgr_ssn).distinct()
# for that way, we would have imported db from flaskDemo, see above

#myChoices2 = [(row[0],row[0]) for row in ssns]  # change

#results=list()
#for row in ssns:
#    rowDict=row._asdict()
#    results.append(rowDict)
#myChoices = [(row['mgr_ssn'],row['mgr_ssn']) for row in results]

#regex1='^((((19|20)(([02468][048])|([13579][26]))-02-29))|((20[0-9][0-9])|(19[0-9][0-9]))-((((0[1-9])'
#regex2='|(1[0-2]))-((0[1-9])|(1\d)|(2[0-8])))|((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30)))))$'
#regex=regex1 + regex2




class RegistrationForm(FlaskForm):
    username = StringField('Username',
                           validators=[DataRequired(), Length(min=2, max=20)])
    
    firstname = StringField('First Name',
                            validators=[DataRequired(), Length(min=1, max=20)])
    lastname = StringField('Last Name',
                            validators=[DataRequired(), Length(min=1, max=20)])

    email = StringField('Email',
                        validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password',
                                     validators=[DataRequired(), EqualTo('password')])

    accounttype = SelectField('Account Type', choices=[("c","Customer"), ("e","Employee")],
                                validators=[DataRequired()])
    submit = SubmitField('Sign Up')

    def validate_username(self, username):
        user = User.query.filter_by(Username=username.data).first()
        if user:
            raise ValidationError('That username is taken. Please choose a different one.')

    def validate_email(self, email):
        user = User.query.filter_by(Email=email.data).first()
        if user:
            raise ValidationError('That email is taken. Please choose a different one.')

class LoginForm(FlaskForm):
    email = StringField('Email',
                        validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    remember = BooleanField('Remember Me')
    submit = SubmitField('Login')

class OrderForm(FlaskForm):
    product = SelectField('Product', validators=[DataRequired()], coerce=int)

    quantity = IntegerField('Quantity', validators=[DataRequired()])

    submit = SubmitField('Place Order')


class OrderViewForm(FlaskForm):
    viewPastOrders = SubmitField('View Past Orders')

class MyReviewsForm(FlaskForm):
    product_id = HiddenField('')
    edit = SubmitField('Edit')
    delete = SubmitField('Delete') 

class ReviewsForm(FlaskForm):
    addReview = SubmitField('Add a Review')
    viewMyReviews = SubmitField('View My Reviews')

    filterBy = SelectField('Filter', coerce=int, choices=[(0,'Most Recent'),(1,'Lowest Rated to Highest'),(2,'Highest Rated to Lowest'),(3,'By Product Name')])
    filterSubmit = SubmitField('Refresh')
       
class AddReviewsForm(FlaskForm):
    product = SelectField('Product', validators=[DataRequired()], coerce=int)
    rating = IntegerField('Rating', validators=[DataRequired()])
    review = StringField('Review', validators=[DataRequired()])
    submit = SubmitField('Submit Review')
    def validate_rating(self, rating):
        if (rating.data < 1 or rating.data > 5):
            raise ValidationError('Rating must be between 1 and 5')
           

class QAAssignForm(FlaskForm):
    employees = SelectField('Employee', coerce=int)
    productAssign = SelectField('Product', coerce=int)
    submit = SubmitField('Assign')

class QAForm(FlaskForm):
    products = SelectField('Product', coerce=int)
    grade = RadioField('Grade', choices=[('pass','Pass'),('fail','Fail')], validators=[DataRequired()])
    submit = SubmitField('Grade')
    
class QADeleteForm(FlaskForm):
    productsGraded = SelectField('Product', coerce=int)
    submit2 = SubmitField('Delete')

class UpdateAccountForm(FlaskForm):
    username = StringField('Username',
                           validators=[DataRequired(), Length(min=2, max=20)])
    email = StringField('Email',
                        validators=[DataRequired(), Email()])

    employees = SelectField('Supervise Employee')
    
    submit = SubmitField('Update')

    def validate_username(self, username):
        if username.data != current_user.Username:
            user = User.query.filter_by(Username=username.data).first()
            if user:
                raise ValidationError('That username is taken. Please choose a different one.')

    def validate_email(self, email):
        if email.data != current_user.Email:
            user = User.query.filter_by(Email=email.data).first()
            if user:
                raise ValidationError('That email is taken. Please choose a different one.')

class PostForm(FlaskForm):
    title = StringField('Title', validators=[DataRequired()])
    content = TextAreaField('Content', validators=[DataRequired()])
    submit = SubmitField('Post')
