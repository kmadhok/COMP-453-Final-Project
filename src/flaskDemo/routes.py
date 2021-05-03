import os
import secrets
from PIL import Image
from flask import render_template, url_for, flash, redirect, request, abort
from flaskDemo import app, db, bcrypt
from flaskDemo.forms import RegistrationForm, LoginForm, UpdateAccountForm, OrderForm, QAAssignForm, QAForm, ReviewsForm, AddReviewsForm
from flaskDemo.models import User, Order, Review, Orderline, Product, QA
from flask_login import login_user, current_user, logout_user, login_required
from datetime import datetime


@app.route("/")
@app.route("/home")
def home():
    # Display last 5 most recent purchases
    ordersQuery = Order.query.with_entities(Order.Order_id).order_by(Order.Order_date.desc()).limit(5)
    orderIDs = list()
    for row in ordersQuery.all():
        rowDict = row._asdict()
        orderIDs.append(rowDict['Order_id'])

    orderlineQuery = db.session.query(Orderline, Order, Product)\
        .select_from(Orderline)\
        .join(Product, Product.Product_id == Orderline.Product_id)\
        .join(Order, Order.Order_id == Orderline.Order_id)\
        .with_entities(Product.Product_id, Product.Description, Orderline.Quantity)\
        .filter(Orderline.Order_id.in_(orderIDs))\
        .order_by(Order.Order_date.desc())

    products = list()
    for row in orderlineQuery.all():
        rowDict = row._asdict()
        products.append((rowDict['Description'], rowDict['Quantity']))
        
    return render_template('home.html', title='Pine Valley', products=products)

@app.route("/reviews", methods=['GET','POST'])
def reviews():
    # Display last 5 most recent reviews
    # Sort by, recent / highest
    reviewQuery = db.session.query(Review, Product)\
        .select_from(Review)\
        .join(Product, Product.Product_id == Review.Product_id)\
        .with_entities(Product.Description, Review.Rating, Review.Review, Review.Review_date)\
        .order_by(Review.Review_date.desc())\
        .limit(10)

    reviews = list()
    for row in reviewQuery.all():
        rowDict = row._asdict()
        reviews.append((rowDict['Description'],rowDict['Rating'],rowDict['Review'],rowDict['Review_date'].strftime("%b %d %Y")))
        
    form = ReviewsForm()
    if form.validate_on_submit():
        if form.addReview.data:
            return redirect(url_for('addReview'))
        if form.filterSubmit.data:
            return redirect(url_for('reviewsFilter',fil=form.filterBy.data))
        
    return render_template('reviews.html', title="Reviews", form=form, reviews=reviews)

@app.route("/reviews/filter/<fil>", methods=['GET','POST'])
def reviewsFilter(fil):
    reviewQuery = db.session.query(Review, Product)\
            .select_from(Review)\
            .join(Product, Product.Product_id == Review.Product_id)\
            .with_entities(Product.Description, Review.Rating, Review.Review, Review.Review_date)\
            .order_by(Review.Review_date.desc())
    if int(fil) == 1:
        reviewQuery = db.session.query(Review, Product)\
            .select_from(Review)\
            .join(Product, Product.Product_id == Review.Product_id)\
            .with_entities(Product.Description, Review.Rating, Review.Review, Review.Review_date)\
            .order_by(Review.Rating)
    elif int(fil) == 2:
        reviewQuery = db.session.query(Review, Product)\
            .select_from(Review)\
            .join(Product, Product.Product_id == Review.Product_id)\
            .with_entities(Product.Description, Review.Rating, Review.Review, Review.Review_date)\
            .order_by(Review.Rating.desc())
    elif int(fil) == 3:
        reviewQuery = db.session.query(Review, Product)\
            .select_from(Review)\
            .join(Product, Product.Product_id == Review.Product_id)\
            .with_entities(Product.Description, Review.Rating, Review.Review, Review.Review_date)\
            .order_by(Product.Description)

    print(reviewQuery)
    reviews = list()
    for row in reviewQuery.all():
        rowDict = row._asdict()
        reviews.append((rowDict['Description'],rowDict['Rating'],rowDict['Review'],rowDict['Review_date'].strftime("%b %d %Y")))
        
    form = ReviewsForm()
    if form.validate_on_submit():
        if form.addReview.data:
            return redirect(url_for('addReview'))
        if form.filterSubmit.data:
            return redirect(url_for('reviewsFilter',fil=form.filterBy.data))
        
    return render_template('reviews.html', title="Reviews", form=form, reviews=reviews)

@app.route("/add-review", methods=['GET','POST'])
@login_required
def addReview():
    products = Product.query.with_entities(Product.Product_id, Product.Description)
    selectList = list()
    for row in products.all():
        rowDict = row._asdict()
        selectList.append((rowDict['Product_id'], rowDict['Description']))
    form = AddReviewsForm()
    form.product.choices = selectList
    
    if form.validate_on_submit():
        review = Review(User_id=current_user.User_id,Product_id=form.product.data,Review=form.review.data,Rating=form.rating.data)
        try:
            db.session.add(review)
            db.session.commit()
        except:
            db.session.rollback()
            db.session.flush()
            flash('Failed to create review. Please try again', 'danger')
            return redirect(url_for('addReview'))
        flash('Review successfully created', 'success')
        return redirect(url_for('reviews'))
 
    return render_template('add_review.html', title="Add Review", form=form)

@app.route("/order", methods=['GET', 'POST'])
@login_required
def order():
    products = Product.query.with_entities(Product.Product_id, Product.Description)
    selectList = list()
    for row in products.all():
        rowDict = row._asdict()
        selectList.append((rowDict['Product_id'], rowDict['Description']))
    form = OrderForm()
    form.product.choices = selectList
    if form.validate_on_submit():
        dateOrdered = datetime.utcnow()
        order = Order(User_id=current_user.User_id, Order_date=dateOrdered)
        db.session.add(order)
        db.session.flush()
        orderline = Orderline(Product_id=form.product.data, Order_id=order.Order_id, Quantity=form.quantity.data)
        db.session.add(orderline)
        db.session.commit()
        return redirect(url_for('home'))
    return render_template('order.html', title="Order", form=form)

@app.route("/qa", methods=['GET','POST'])
@login_required
def qa():
    isSupervisor = len(User.query.filter_by(Supervisor=current_user.User_id).all()) > 0
    aform = QAAssignForm()
    if isSupervisor:
        employees = User.query.with_entities(User.User_id, User.FirstName, User.LastName).filter_by(Supervisor=current_user.User_id)
        empList = list()
        for row in employees.all():
            rowDict = row._asdict()
            empList.append((rowDict['User_id'], rowDict['FirstName'] + ' ' + rowDict['LastName']))
        products = Product.query.with_entities(Product.Product_id, Product.Description)
        prodlist = list()
        for row in products.all():
            rowDict = row._asdict()
            prodlist.append((rowDict['Product_id'], rowDict['Description']))
   
        aform.employees.choices = empList
        aform.productAssign.choices = prodlist

    products = db.session.query(QA, Product)\
        .select_from(QA)\
        .join(Product, Product.Product_id == QA.Product_id)\
        .with_entities(Product.Product_id, Product.Description)\
        .filter(QA.User_id==current_user.User_id, QA.Rating==None)
    reviewList = list()
    for row in products.all():
        rowDict = row._asdict()
        reviewList.append((rowDict['Product_id'], rowDict['Description']))
    form = QAForm()
    form.products.choices = reviewList
    if aform.validate_on_submit():
        return redirect(url_for('qaAssign', User_id=aform.employees.data, Product_id=aform.productAssign.data))
    if form.validate_on_submit():
        return redirect(url_for('qaGrade', User_id=current_user.User_id, Product_id=form.products.data, grade=form.grade.data))
    return render_template('qa.html', title='Quality Assurance', isSupervisor=isSupervisor, aform=aform, form=form)

@app.route("/qa/assign/<User_id>/<Product_id>", methods=['GET','POST'])
@login_required
def qaAssign(User_id, Product_id):
    qa = QA(User_id=User_id, Product_id=Product_id)
    db.session.add(qa)
    db.session.commit()
    flash('Employee assigned to product successfully', 'success')
    return redirect(url_for('qa'))

@app.route("/qa/grade/<User_id>/<Product_id>/<grade>", methods=['GET','POST'])
@login_required
def qaGrade(User_id, Product_id, grade):
    failed = False
    try:
        qa = QA.query.filter_by(User_id=User_id,Product_id=Product_id).first()
        qa.Rating = grade
        db.session.commit()
    except:
        db.session.rollback()
        db.session.flush()
        failed = True
    
    if failed:
        flash('Failed to grade assignment. Please try again', 'danger')
        return redirect(url_for('qa'))

    flash('Product graded successfully', 'success')
    return redirect(url_for('qa'))

@app.route("/register", methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        user = User(Username=form.username.data, FirstName=form.firstname.data, LastName=form.lastname.data, Email=form.email.data, Password=hashed_password, AccountType=form.accounttype.data)
        db.session.add(user)
        db.session.commit()
        flash('Your account has been created! You are now able to log in', 'success')
        return redirect(url_for('login'))
    return render_template('register.html', title='Register', form=form)


@app.route("/login", methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(Email=form.email.data).first()
        if user and bcrypt.check_password_hash(user.Password, form.password.data):
            login_user(user, remember=form.remember.data)
            next_page = request.args.get('next')
            return redirect(next_page) if next_page else redirect(url_for('home'))
        else:
            flash('Login Unsuccessful. Please check email and password', 'danger')
    return render_template('login.html', title='Login', form=form)

@app.route("/logout")
def logout():
    logout_user()
    return redirect(url_for('home'))


@app.route("/account", methods=['GET', 'POST'])
@login_required
def account():
    employees = User.query.with_entities(User.User_id, User.FirstName, User.LastName).filter_by(AccountType='e', Supervisor=current_user.User_id)
    isSupervisor = len(employees.all()) > 0
    selectList = list()
    selectList.append((-1,""))
    if isSupervisor:
        notSupervising = User.query.with_entities(User.User_id, User.FirstName, User.LastName).filter(User.AccountType=='e', User.Supervisor==None, User.User_id!=current_user.User_id)
        results = notSupervising.all()
        for row in notSupervising.all():
            rowDict = row._asdict()
            selectList.append((rowDict['User_id'], rowDict['FirstName'] + ' ' + rowDict['LastName']))
     
    form = UpdateAccountForm()
    form.employees.choices = selectList
    if form.validate_on_submit():
        current_user.Username = form.username.data
        current_user.Email = form.email.data
        if int(form.employees.data) != -1:
            employee = User.query.filter_by(User_id=form.employees.data).first()
            employee.Supervisor = current_user.User_id
        db.session.commit()
        flash('Your account has been updated!', 'success')
        return redirect(url_for('account'))
    elif request.method == 'GET':
        form.username.data = current_user.Username
        form.email.data = current_user.Email
    return render_template('account.html', title='Account', isSupervisor=isSupervisor, form=form)












































@app.route("/dept/new", methods=['GET', 'POST'])
@login_required
def new_dept():
    form = DeptForm()
    if form.validate_on_submit():
        dept = Department(dname=form.dname.data, dnumber=form.dnumber.data,mgr_ssn=form.mgr_ssn.data,mgr_start=form.mgr_start.data)
        db.session.add(dept)
        db.session.commit()
        flash('You have added a new department!', 'success')
        return redirect(url_for('home'))
    return render_template('create_dept.html', title='New Department',
                           form=form, legend='New Department')


@app.route("/dept/<dnumber>")
@login_required
def dept(dnumber):
    dept = Department.query.get_or_404(dnumber)
    return render_template('dept.html', title=dept.dname, dept=dept, now=datetime.utcnow())

@app.route("/dept/<dnumber>/update", methods=['GET', 'POST'])
@login_required
def update_dept(dnumber):
    dept = Department.query.get_or_404(dnumber)
    currentDept = dept.dname

    form = DeptUpdateForm()
    if form.validate_on_submit():          # notice we are are not passing the dnumber from the form
        if currentDept !=form.dname.data:
            dept.dname=form.dname.data
        dept.mgr_ssn=form.mgr_ssn.data
        dept.mgr_start=form.mgr_start.data
        db.session.commit()
        flash('Your department has been updated!', 'success')
        return redirect(url_for('dept', dnumber=dnumber))
    elif request.method == 'GET':              # notice we are not passing the dnumber to the form

        form.dnumber.data = dept.dnumber
        form.dname.data = dept.dname
        form.mgr_ssn.data = dept.mgr_ssn
        form.mgr_start.data = dept.mgr_start
    return render_template('create_dept.html', title='Update Department',
                           form=form, legend='Update Department')




@app.route("/dept/<dnumber>/delete", methods=['POST'])
@login_required
def delete_dept(dnumber):
    dept = Department.query.get_or_404(dnumber)
    db.session.delete(dept)
    db.session.commit()
    flash('The department has been deleted!', 'success')
    return redirect(url_for('home'))



@app.route("/projects", methods=['GET'])
def project():
    query = db.session.query(Works_On, Employee, Project)\
        .select_from(Works_On)\
        .join(Employee, Employee.ssn == Works_On.essn)\
        .join(Project, Project.pnumber == Works_On.pno)\
        .with_entities(Employee.fname, Employee.minit, Employee.lname, Project.pname, Works_On.pno)\
        .order_by(Project.pname)

    results = list()
    for row in query.all():
        rowDict = row._asdict()
        results.append(rowDict)

    return render_template('projects.html', title='Projects', projects=results)

@app.route("/project/<pnumber>", methods=['GET','POST'])
@login_required
def proj(pnumber):
    query = db.session.query(Works_On, Employee, Project)\
        .select_from(Works_On)\
        .join(Employee, Employee.ssn == Works_On.essn)\
        .join(Project, Project.pnumber == Works_On.pno)\
        .with_entities(Employee.ssn, Employee.fname, Employee.minit, Employee.lname, Project.pname, Works_On.pno)\
        .filter(Works_On.pno == pnumber)

    results = list()
    employees = list()
    for row in query.all():
        rowDict = row._asdict()
        results.append(rowDict)
        employees.append((rowDict['ssn'],rowDict['fname'] + ' ' + rowDict['minit'] + '. ' + rowDict['lname']))

    form = RemoveEmployee()
    form.employee.choices = employees

    return render_template('proj.html', title=results[0]['pname'], project=results, form=form)


@app.route("/assign", methods=['GET','POST'])
def assign():
    empQuery = Employee.query.with_entities(Employee.fname, Employee.lname, Employee.ssn)
    projQuery = Project.query.with_entities(Project.pnumber, Project.pname)

    employees = list() 
    for row in empQuery.all():
        rowDict = row._asdict()
        employees.append((rowDict['ssn'],rowDict['fname'] + ' ' + rowDict['lname']))


    projects = list()
    for row in projQuery.all():
        rowDict = row._asdict()
        projects.append((rowDict['pnumber'],rowDict['pname']))

    form = AssignForm()
    form.employees.choices = employees
    form.projects.choices = projects

    if form.validate_on_submit():          # notice we are are not passing the dnumber from the form
        if form.submit.data:
           return redirect(url_for('assign_employee', pnumber=form.projects.data, ssn=form.employees.data), code=307)
        elif form.remove.data:
            return redirect(url_for('remove_employee', pnumber=form.projects.data, ssn=form.employees.data), code=307)

    return render_template('assign.html', title="Assign", form=form)

@app.route("/project/<pnumber>/assign-emp/<ssn>", methods=['POST'])
@login_required
def assign_employee(pnumber, ssn):
    found = Works_On.query.filter(Works_On.essn == ssn, Works_On.pno == pnumber).first()
    if found:
        flash(u'Employee already assigned to project', category='danger')
        return redirect(url_for('assign'))
    works = Works_On(pno=pnumber,essn=ssn,hours=0)
    db.session.add(works)
    db.session.commit()
    flash('Successfully added assignment', 'success')
    return redirect(url_for('project'))

@app.route("/project/<pnumber>/remove-emp/<ssn>", methods=['POST'])
@login_required
def remove_employee(pnumber, ssn):
    found = Works_On.query.filter(Works_On.essn == ssn, Works_On.pno == pnumber).first()
    if not found:
        flash(u'Employee not assigned to project', 'danger')
        return redirect(url_for('assign'))
    row = Works_On.query.filter(Works_On.essn == ssn, Works_On.pno == pnumber).first()
    db.session.delete(row)
    db.session.commit()
    flash('Successfully removed assignement', 'success')
    return redirect(url_for('project'))
    