import os
import secrets
from PIL import Image
from flask import render_template, url_for, flash, redirect, request, abort
from flaskDemo import app, db, bcrypt
from flaskDemo.forms import RegistrationForm, LoginForm, UpdateAccountForm, PostForm, DeptForm, DeptUpdateForm, RemoveEmployee, AssignForm
from flaskDemo.models import User, Post,Department, Dependent, Dept_Locations, Employee, Project, Works_On
from flask_login import login_user, current_user, logout_user, login_required
from datetime import datetime


@app.route("/")
@app.route("/home")
def home():
    results = Department.query.all()
    return render_template('dept_home.html', outString = results)
    posts = Post.query.all()
    return render_template('home.html', posts=posts)
    results2 = Faculty.query.join(Qualified,Faculty.facultyID == Qualified.facultyID) \
               .add_columns(Faculty.facultyID, Faculty.facultyName, Qualified.Datequalified, Qualified.courseID) \
               .join(Course, Course.courseID == Qualified.courseID).add_columns(Course.courseName)
    results = Faculty.query.join(Qualified,Faculty.facultyID == Qualified.facultyID) \
              .add_columns(Faculty.facultyID, Faculty.facultyName, Qualified.Datequalified, Qualified.courseID)
    return render_template('join.html', title='Join',joined_1_n=results, joined_m_n=results2)

   


@app.route("/about")
def about():
    return render_template('about.html', title='About')

@app.route("/reviews", methods=['GET'])
def reviews():
    return render_template('reviews.html', title="Reviews")

@app.route("/order", methods=['GET'])
def order():
    return render_template('order.html', title="Order")


@app.route("/register", methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        user = User(username=form.username.data, email=form.email.data, password=hashed_password)
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
        user = User.query.filter_by(email=form.email.data).first()
        if user and bcrypt.check_password_hash(user.password, form.password.data):
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


def save_picture(form_picture):
    random_hex = secrets.token_hex(8)
    _, f_ext = os.path.splitext(form_picture.filename)
    picture_fn = random_hex + f_ext
    picture_path = os.path.join(app.root_path, 'static/profile_pics', picture_fn)

    output_size = (125, 125)
    i = Image.open(form_picture)
    i.thumbnail(output_size)
    i.save(picture_path)

    return picture_fn


@app.route("/account", methods=['GET', 'POST'])
@login_required
def account():
    form = UpdateAccountForm()
    if form.validate_on_submit():
        if form.picture.data:
            picture_file = save_picture(form.picture.data)
            current_user.image_file = picture_file
        current_user.username = form.username.data
        current_user.email = form.email.data
        db.session.commit()
        flash('Your account has been updated!', 'success')
        return redirect(url_for('account'))
    elif request.method == 'GET':
        form.username.data = current_user.username
        form.email.data = current_user.email
    image_file = url_for('static', filename='profile_pics/' + current_user.image_file)
    return render_template('account.html', title='Account',
                           image_file=image_file, form=form)












































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
    