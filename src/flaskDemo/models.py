from datetime import datetime
from flaskDemo import db, login_manager
from flask_login import UserMixin
from functools import partial
from sqlalchemy import orm

db.Model.metadata.reflect(db.engine)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(db.Model, UserMixin):
    __tablename__ = "User_t"
    __table_args__ = {'extend_existing': True}
    User_id = db.Column(db.Integer, primary_key=True)
    Username = db.Column(db.String(25), unique=True, nullable=False)
    Email = db.Column(db.String(120), unique=True, nullable=False)
    FirstName = db.Column(db.String(25), nullable=False)
    LastName = db.Column(db.String(25), nullable=False)
    AccountType = db.Column(db.String(1), nullable=False)
    Password = db.Column(db.String(60), nullable=False)

    def get_id(self):
           return (self.User_id)

    def __repr__(self):
        return f"User('{self.username}', '{self.email}')"


class Order(db.Model):
    __table__ = db.Model.metadata.tables['Order_t']

class Review(db.Model):
    __table__ = db.Model.metadata.tables['Review_t']

class Product(db.Model):
    __table__ = db.Model.metadata.tables['Product_t']

class Orderline(db.Model):
    __table__ = db.Model.metadata.tables['Orderline_t']
    

  
