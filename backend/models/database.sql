DROP DATABASE cureapp_5;
CREATE DATABASE cureapp_5;

\c cureapp_5;


CREATE TABLE roles (
  role_id SERIAL NOT NULL,
  role VARCHAR(255) NOT NULL,
  PRIMARY KEY (role_id)
);

CREATE TABLE permissions (
permission_id SERIAL NOT NULL,
permission VARCHAR(255) NOT NULL,
PRIMARY KEY (permission_id)
);


CREATE TABLE role_permissions(
role_permission_id SERIAL NOT NULL,
role_id INT,
permission_id INT,
FOREIGN KEY (role_id) REFERENCES roles(role_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
FOREIGN KEY (permission_id) REFERENCES permissions(permission_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
PRIMARY KEY (role_permission_id)
);

CREATE TABLE users(
  user_id SERIAL NOT NULL,
  firstName VARCHAR(255) NOT NULL,
  lastName VARCHAR(255) NOT NULL,
  birthDate DATE NOT NULL,
  city VARCHAR(255),
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phoneNumber VARCHAR(100) NOT NULL,
  role_id INT,
FOREIGN KEY (role_id) REFERENCES roles(role_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
gender VARCHAR (100) ,
is_deleted SMALLINT DEFAULT 0,
 
PRIMARY KEY (user_id),
users_email_key CHECK  (email like '%_@__%.__%') 


);

CREATE TABLE categories(
category_id SERIAL PRIMARY KEY NOT NULL ,
category VARCHAR(255),
img TEXT,
is_deleted SMALLINT DEFAULT 0
);

CREATE TABLE providers(
provider_id SERIAL PRIMARY KEY NOT NULL,
fName VARCHAR(255) NOT NULL,
lName VARCHAR(255) NOT NULL,
birthDate DATE NOT NULL,
email VARCHAR(255) UNIQUE NOT NULL,
password VARCHAR(255) NOT NULL ,
phoneNumber VARCHAR(100) NOT NULL,
city VARCHAR(255) ,
gender  VARCHAR(255) NOT NULL,
category_id INT NOT NULL ,
role_id INT ,
FOREIGN KEY (role_id) REFERENCES roles(role_id)
ON UPDATE CASCADE
 ON DELETE CASCADE,
FOREIGN KEY (category_id) REFERENCES categories(category_id)
ON UPDATE CASCADE
 ON DELETE CASCADE,
is_deleted SMALLINT DEFAULT 0

);

CREATE TABLE services(
service_id SERIAL PRIMARY KEY NOT NULL ,
service VARCHAR(1000) NOT NULL ,
price_per_hour INT,
provider_id INT,
FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
ON UPDATE CASCADE
ON DELETE CASCADE,

is_deleted SMALLINT DEFAULT 0
);

CREATE TABLE schedules(
schedule_id SERIAL PRIMARY KEY NOT NULL ,
time_from TIME NOT NULL,
time_to TIME NOT NULL,
DATE date ,
provider_id INT,
FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
is_deleted SMALLINT DEFAULT 0,

FOREIGN KEY (user_id) REFERENCES users(user_id)
ON UPDATE CASCADE
ON DELETE CASCADE,

Date DATE ,


booked BOOLEAN DEFAULT false,
chosen BOOLEAN DEFAULT true,
is_viewed SMALLINT DEFAULT 1
);

create table reviews(
review_id SERIAL PRIMARY KEY NOT NULL,
user_id INT,
FOREIGN KEY (user_id) REFERENCES users(user_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
provider_id INT,
FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
review TEXT,
created_at TIMESTAMP DEFAULT NOW(),
is_deleted SMALLINT DEFAULT  0

);






CREATE TABLE orders(
order_id SERIAL PRIMARY KEY NOT NULL ,
service_id INT NOT NULL ,
FOREIGN KEY (service_id) REFERENCES services(service_id)
ON UPDATE CASCADE 
ON DELETE CASCADE,
provider_id INT NOT NULL,
FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
ON UPDATE CASCADE 
ON DELETE CASCADE,
user_id INT NOT NULL ,
FOREIGN KEY (user_id) REFERENCES users(user_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
created_at TIMESTAMP DEFAULT NOW(),
is_deleted  SMALLINT DEFAULT 0,
status VARCHAR DEFAULT 'pending',
schedule_id INT,
FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id)
ON UPDATE CASCADE
ON DELETE CASCADE
);

CREATE TABLE provider_info(
provider_info_id SERIAL PRIMARY KEY NOT NULL,
img TEXT DEFAULT 'https://res.cloudinary.com/drzcyo3sv/image/upload/v1697044081/Provider_fobelh.jpg',
bio TEXT NOT NULL,
qualifications TEXT NOT NULL,
provider_id INT NOT NULL,
FOREIGN KEY (provider_id) REFERENCES providers(provider_id)

ON UPDATE CASCADE

ON DELETE CASCADE,
is_deleted SMALLINT DEFAULT 0
);

CREATE TABLE provider_notes(
provider_note_id SERIAL PRIMARY KEY NOT NULL ,
user_id INT NOT NULL,
FOREIGN KEY (user_id) REFERENCES users(user_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
provider_id INT,
FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
ON UPDATE CASCADE ON DELETE CASCADE,
visitied_on TIMESTAMP DEFAULT NOW (),
note TEXT NOT NULL,
is_deleted SMALLINT DEFAULT 0
);

CREATE TABLE medical_history(
medical_history_id SERIAL PRIMARY KEY NOT NULL,
user_id INT,
FOREIGN KEY (user_id) REFERENCES users(user_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
history TEXT,
medications TEXT,
chronic_diseases  TEXT,
is_deleted SMALLINT DEFAULT 0
);

INSERT INTO roles (role) VALUES ('Admin'),('User'),('Provider'); 
INSERT INTO permissions (permission) VALUES (''),(''),(''); 
INSERT INTO role_permissions (role_id,permission_id) VALUES ('',''),('',''),('',''); 

---=========================== insert category =========================
 INSERT INTO categories (category,img) VALUES ('General Medicine','img'),('Nursing',''),('Physiotherapy',''),('Occupational Therapy',''),('Speech Therapy',''),('Baby Sitting','');


INSERT INTO categories (category ,img)VALUES ('Babysitting' ,'https://www.shutterstock.com/shutterstock/photos/1686880690/display_1500/stock-vector-mother-playing-with-kids-at-home-educational-toys-children-playing-designer-cubes-developmental-1686880690.jpg') 
INSERT INTO categories (category ,img)VALUES ('Speech Therapy' ,'https://www.starhealth.in/blog/wp-content/uploads/2022/06/SPEECH-THERAPY.jpg') 
INSERT INTO categories (category ,img)VALUES ('Occupational Therapy','https://web.goodhealthcontent.com//imagecache/App__Models__CMS__Item__Image__ImageResource__5690//1280__0__c3.jpg') 
INSERT INTO categories (category ,img)VALUES ('Physiotherapy' ,'https://blogs.dpuerp.in/images/blog/7/362-physiotherapy-decoding-myths-and-facts.jpg') 
INSERT INTO categories (category,img)VALUES ('Laboratory','https://static.vecteezy.com/system/resources/thumbnails/007/192/085/small/two-scientists-working-isolated-on-a-white-background-vector.jpg') 
INSERT INTO categories (category ,img)VALUES ('Nursing' ,'https://clipartix.com/wp-content/uploads/2016/06/Search-results-search-results-for-nurse-pictures-graphics-cliparts.jpg') 
INSERT INTO categories (category , img) VALUES ('	General Medicine','https://igch.in/public/uploads/2019-06-23/general-medicine.jpg')

--===========================insert provider======================================
--===================genera medicine ===================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('khaled','tarawneh','1995-8-20','male','khaled@gmail.com','12369874','Amman','962791486451',3, 'general medicine') RETURNING *


  INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/6129104/pexels-photo-6129104.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I am Khalid a passionate doctor who swore to save lives,I finished my bachelors degree from University Of Jordan with an excellent degree,proud of what I am and more for what I give people','-Bachelors in Doctor Of Medicine - 3 years of experience in emergency of Al-Basheer Goverment Hospital ',"Khaled") RETURNING *

  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Consultaion',25,"Khaled") RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Wound Dressing',30,"Khaled") RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Minor Wounds Suturing',40,"Khaled") RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypoglycemia First Aid',15,"Khaled") RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypertension First Aid',15,"Khaled") RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('diabetic foot ulcer care education',10,"Khaled") RETURNING *


--====================================================Khaled
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Ahmad','Alajloni','1990-8-2','male','Ahmed@gmail.com','258741369','Ajlone','962789412656',3, 'general medicine') RETURNING *

  INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/4270371/pexels-photo-4270371.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I am Ahmad a passionate doctor who swore to save lives,I finished my bachelors degree from Mutah University with an excellent degree,proud of what I am and more for what I give people','-Bachelors in Doctor Of Medicine - 2 years of experience in Jordan Hospital',21) RETURNING *

   INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Consultaion',25,,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Wound Dressing',30,,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Minor Wounds Suturing',40,,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypoglycemia First Aid',15,
,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypertension First Aid',15,
,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('diabetic foot ulcer care education',10
,8) RETURNING *

--====================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Husam','Tarawneh','1993-2-20','male','husam@gmail.com','12369874','Al-Karak','0798642631',3, 'general medicine') RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/3779702/pexels-photo-3779702.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I am Husam a passionate doctor who swore to save lives,I finished my bachelors degree from Mutah University with a very good degree,proud of what I am and more for what I give people','-Bachelors in Doctor Of Medicine - 1 year of experience in Al-Kendi Hospital',21) RETURNING *

   INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Consultaion',25,,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Wound Dressing',30,,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Minor Wounds Suturing',40,,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypoglycemia First Aid',15,
,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypertension First Aid',15,
,8) RETURNING *
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('diabetic foot ulcer care education',10
,8) RETURNING *
--=====================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Nawal','Mousa','1986-4-7','female','nawal@gmail.com','12369874','Irbid','0785654562',3, 'general medicine') RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/5206931/pexels-photo-5206931.jpeg?auto=compress&cs=tinysrgb&w=600
','I am Nawal a passionate doctor who swore to save lives,I finished my bachelors degree from Mutah University with a very good degree,proud of what I am and more for what I give people','-Bachelors in Doctor Of Medicine - 10 year of experience in King Hussein Medical City-Bachelors in Doctor Of Medicine - 1 year of experience in Al-Kendi Hospital',4) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Consultaion',25,4) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Wound Dressing',30,4) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Minor Wounds Suturing',40,4) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypoglycemia First Aid',15,
4) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypertension First Aid',15,
4) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('diabetic foot ulcer care education',10
,4) RETURNING *;
--==================================================
  INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Malak','Mansor','1990-7-20','female','malak@gmail.com','12369874','Zarqa','9631486451',3,8) RETURNING *
INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/5327585/pexels-photo-5327585.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load
','I am Malak a passionate doctor who swore to save lives,I finished my bachelors degree from University Of Jordan with a very good degree,proud of what I am and more for what I give people','-Bachelors in Doctor Of Medicine - 1 year of experience in Al-Kendi Hospital',5) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Consultaion',25,5) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Wound Dressing',30,5) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Minor Wounds Suturing',40,5) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypoglycemia First Aid',15,
5) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hypertension First Aid',15,
5) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('diabetic foot ulcer care education',10
,5) RETURNING *;
--===================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Naya','Al-zoubi','1991-6-20','female','naya@gmail.com','12369874','As-salt','0789865654',3, '8') RETURNING *
INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/4173248/pexels-photo-4173248.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load','I am Naya a passionate doctor who swore to save lives,I finished my bachelors degree from Mutah University with a very good degree,proud of what I am and more for what I give people','-Bachelors in Doctor Of Medicine - 1 year of experience in Al-Kendi Hospital',6) RETURNING *,
--===================== nurse============================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Muhamad','Hasan','1995-8-20','male','muhamad@gmail.com','12369874','Amman','9631486451',3, 'Nurse') RETURNING *
INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/6303564/pexels-photo-6303564.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I am Hussam ,called as mercy angel and hoping always to deserve this title'
 ,'-Bachelors in Nursing - 1 year of experience in Al-Kendi Hospital',7) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Intravenous (IV) care, including injections, IV hydration and IV feeding',15,7) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medication management and supervision',25,7) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Respiratory care and therapy',20,7) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medical monitoring, including tracking of vital signs and medical condition',30,7) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Specialty services, like stroke, cardiac, orthopedic',40,7) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Complex wound care, such as care and dressing of surgical wounds or specialized care of decubutis ulcers (bed sores)',35,7) RETURNING *;
 
--======================================================
  INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Yazan','Abdullah','1996-3-20','male','yazan@gmail.com','12369874','Mafraq',
  '9631486451',3, 9) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/7584492/pexels-photo-7584492.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I am Hussam ,called as mercy angel and hoping always to deserve this title 
 ','-Bachelors in test- 1 year of experience in Al-Kendi Hospital',8) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Intravenous (IV) care, including injections, IV hydration and IV feeding',15,8) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medication management and supervision',25,8) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Respiratory care and therapy',20,8) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medical monitoring, including tracking of vital signs and medical condition',30,8) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Specialty services, like stroke, cardiac, orthopedic',40,8) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Complex wound care, such as care and dressing of surgical wounds or specialized care of decubutis ulcers (bed sores)',35,8) RETURNING *;
--======================================================
   INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Obada','Ahmed','1995-9-7','male','obada@gmail.com','12369874','Zarqa','9631486451',3, 'nurse') RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/6235010/pexels-photo-6235010.jpeg?auto=compress&cs=tinysrgb&w=600','called as mercy angel and hoping always to deserve this title 
 ','-Bachelors in test- 1 year of experience in Al-Kendi Hospital',9) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Intravenous (IV) care, including injections, IV hydration and IV feeding',15,9) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medication management and supervision',25,9) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Respiratory care and therapy',20,9) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medical monitoring, including tracking of vital signs and medical condition',30,9) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Specialty services, like stroke, cardiac, orthopedic',40,9) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Complex wound care, such as care and dressing of surgical wounds or specialized care of decubutis ulcers (bed sores)',35,9) RETURNING *;
--====================================================


   INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Othman','Awawdeh','1998-5-20','male','othman@gmail.com','12369874','As-salat','9631486451',3, 'nurse') RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/5888144/pexels-photo-5888144.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','called as mercy angel and hoping always to deserve this title','-Bachelors in test- 1 year of experience in Al-Kendi Hospital',10) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Intravenous (IV) care, including injections, IV hydration and IV feeding',15,10) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medication management and supervision',25,10) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Respiratory care and therapy',20,10) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medical monitoring, including tracking of vital signs and medical condition',30,10) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Specialty services, like stroke, cardiac, orthopedic',40,10) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Complex wound care, such as care and dressing of surgical wounds or specialized care of decubutis ulcers (bed sores)',35,10) RETURNING *;
--=====================================================
   INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Dema','Alshami','2000-9-4','female','dema@gmail.com','12369874','Az-zarqa','9631486451',3, 'nurse') RETURNING *


INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/4482887/pexels-photo-4482887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','test ','test',11) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Intravenous (IV) care, including injections, IV hydration and IV feeding',15,11) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medication management and supervision',25,11) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Respiratory care and therapy',20,11) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medical monitoring, including tracking of vital signs and medical condition',30,11) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Specialty services, like stroke, cardiac, orthopedic',40,11) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Complex wound care, such as care and dressing of surgical wounds or specialized care of decubutis ulcers (bed sores)',35,11) RETURNING *;
--====================================================
 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Rahaf','Mahmud','1999-3-20','female','rahaf@gmail.com','12369874','Ajloun','9631486451',3, 9) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/5207087/pexels-photo-5207087.jpeg?auto=compress&cs=tinysrgb&w=600','I am Rahaf ,called as mercy angel and hoping always to deserve this title 
 ','-Bachelors degree in Nursing- 1 year of experience in Al-Kendi Hospital',12) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Intravenous (IV) care, including injections, IV hydration and IV feeding',15,14) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medication management and supervision',25,13) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Respiratory care and therapy',20,13) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Medical monitoring, including tracking of vital signs and medical condition',30,13) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Specialty services, like stroke, cardiac, orthopedic',40,13) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Complex wound care, such as care and dressing of surgical wounds or specialized care of decubutis ulcers (bed sores)',35,13) RETURNING *;
--==================== laboratory ====================
 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Mazen','Abdullah','1996-3-20','male','mazen@gmail.com','12369874','Amman','9631486451',3, 'laboratory') RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/7407050/pexels-photo-7407050.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I love my job and I hope that we as medical teams find the cure for every disease  
','-Bachelors in Medical Laboratory Sciences from University of Jordan- 1 year of experience in Al-Esraa Hospital',13) RETURNING 
*
--======================================================

 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Mariam','Khalilah','1997-5-20','female','mariam@gmail.com','12369874','Al-Zarqa','9631486451',3, 'laboratory') RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/4492048/pexels-photo-4492048.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I love my job and I hope that we as medical teams find the cure for every disease  
','-Bachelors in Medical Laboratory Sciences from Hashemite University- 1 year of experience in Al-Esraa Hospital',14) RETURNING *

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('CBC (Complete Blood Count),ESR (Erythrocyte Sedimentation Rate)Test',15,14) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('TSH (Thyroid Stimulating Hormone),FT3 (Free Triiodothyronine),FT4 (Free Thyroxine)',20,14) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hemoglobin A1C(HBA1C),FBC(Fasting Blood Sugur)',15,14) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Vitamin B12,Ferritin,Vitamin D3',35,14) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Lipid Panel(HDL,LDL,TRIG,CHOL)',30,14) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Kidny Function Test (Urea,Createnine) ,Electrolyts (Na,K,CL)',10,14) RETURNING *;
--===========================================================
 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Shahed','Muhamad','1996-3-20','female','shahed@gmail.com','12369874','Maan','9631486451',3, 'laboratory') RETURNING *

  INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/3938022/pexels-photo-3938022.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I love my job and I hope that we as medical teams find the cure for every disease  
','-Bachelors in Medical Laboratory Sciences from Hashemite University- 1 year of experience in Al-Esraa Hospital',15) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('CBC (Complete Blood Count),ESR (Erythrocyte Sedimentation Rate)Test',15,15) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('TSH (Thyroid Stimulating Hormone),FT3 (Free Triiodothyronine),FT4 (Free Thyroxine)',20,15) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hemoglobin A1C(HBA1C),FBC(Fasting Blood Sugur)',15,15) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Vitamin B12,Ferritin,Vitamin D3',35,15) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Lipid Panel(HDL,LDL,TRIG,CHOL)',30,15) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Kidny Function Test (Urea,Createnine) ,Electrolyts (Na,K,CL)',10,15) RETURNING *;
  --============================================================

 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Duha','Jehad','2000-7-7','female','duha@gmail.com','12369874','Amman','9631486451',3, 10) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/3735780/pexels-photo-3735780.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I love my job and I hope that we as medical teams find the cure for every disease  
','-Bachelors in Medical Laboratory Sciences from Hashemite University- 1 year of experience in Al-Esraa Hospital',16) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('CBC (Complete Blood Count),ESR (Erythrocyte Sedimentation Rate)Test',15,16) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('TSH (Thyroid Stimulating Hormone),FT3 (Free Triiodothyronine),FT4 (Free Thyroxine)',20,16) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hemoglobin A1C(HBA1C),FBC(Fasting Blood Sugur)',15,16) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Vitamin B12,Ferritin,Vitamin D3',35,16) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Lipid Panel(HDL,LDL,TRIG,CHOL)',30,16) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Kidny Function Test (Urea,Createnine) ,Electrolyts (Na,K,CL)',10,16) RETURNING *;
--==============================================================


 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Mamon','Subhi','1996-3-20','male','mamon@gmail.com','12369874','Aqaba','9631486451',3, 10) RETURNING *

  INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://akm-img-a-in.tosshub.com/indiatoday/images/story/202212/image_1-sixteen_nine.jpg?VersionId=HaFslkFVjsp97SiVvDeUjI._sC89yIza&size=690:388','I love my job and I hope that we as medical teams find the cure for every disease  
','-Bachelors in Medical Laboratory Sciences from Hashemite University- 1 year of experience in Al-Esraa Hospital',17) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('CBC (Complete Blood Count),ESR (Erythrocyte Sedimentation Rate)Test',15,17) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('TSH (Thyroid Stimulating Hormone),FT3 (Free Triiodothyronine),FT4 (Free Thyroxine)',20,17) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hemoglobin A1C(HBA1C),FBC(Fasting Blood Sugur)',15,17) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Vitamin B12,Ferritin,Vitamin D3',35,17) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Lipid Panel(HDL,LDL,TRIG,CHOL)',30,17) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Kidny Function Test (Urea,Createnine) ,Electrolyts (Na,K,CL)',10,17) RETURNING *;
  --================================================================

 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Mustafa','Khaled','1998-5-20','male','mustafa@gmail.com','12369874','Amman','9631486451',3, 10) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/6129868/pexels-photo-6129868.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I love my job and I hope that we as medical teams find the cure for every disease  
','-Bachelors in Medical Laboratory Sciences- 1 year of experience in Al-Esraa Hospital',18) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('CBC (Complete Blood Count),ESR (Erythrocyte Sedimentation Rate)Test',15,18) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('TSH (Thyroid Stimulating Hormone),FT3 (Free Triiodothyronine),FT4 (Free Thyroxine)',20,18) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Hemoglobin A1C(HBA1C),FBC(Fasting Blood Sugur)',15,18) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Vitamin B12,Ferritin,Vitamin D3',35,18) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Lipid Panel(HDL,LDL,TRIG,CHOL)',30,18) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Kidny Function Test (Urea,Createnine) ,Electrolyts (Na,K,CL)',10,18) RETURNING *;
--============================ Physiotherapy ==================
 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Mustafa','Ayman','1998-5-20','male','mustafa22@gmail.com','12369874','Amman','9631486451',3, 11) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://www.canva.com/design/DAFxC4ecPac/C1ptl_fkkooJ_o8nH3Ch6Q/view?utm_content=DAFxC4ecPac&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink','I am always proud of being part of recovering someones life and leading them to their full capacity of stregnth and independency step by step 
','Bachelors in Physiotherapy from Hashemite University
- 1 year of experience in Al-Esraa Hospital
',11) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Sports Physiotherapy',10,19) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Geriatric Physiotherapy',20,19) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Orthopedic Physiotherapy',15,19) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Pediatric Physiotherapy',35,19) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Neurological Physiotherapy',30,19) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Cardiovascular Physiotherapy',40,19) RETURNING *;
--============================================================
 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Khaldon','Marar','1998-5-20','male','khaldon@gmail.com','12369874','Az-zarqa','9631486451',3, 11) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/3777575/pexels-photo-3777575.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load','I am always proud of being part of recovering someones life and leading them to their full capacity of stregnth and independency step by step','
-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in Al-Esraa Hospital
',22) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Sports Physiotherapy',10,22) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Geriatric Physiotherapy',20,22) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Orthopedic Physiotherapy',15,22) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Pediatric Physiotherapy',35,22) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Neurological Physiotherapy',30,22) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Cardiovascular Physiotherapy',40,22) RETURNING *;
--===========================================================
 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Amer','Mohsen','1995-8-10','male','Amer@gmail.com','12369874','Mafraq','9631486451',3, 11) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/5039639/pexels-photo-5039639.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','I am always proud of being part of recovering someones life and leading them to their full capacity of stregnth and independency step by step 
','-Bachelors in Physiotherapy from Hashemite University
- 3 year of experience in Physio One center
',23) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Sports Physiotherapy',10,23) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Geriatric Physiotherapy',20,23) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Orthopedic Physiotherapy',15,23) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Pediatric Physiotherapy',35,23) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Neurological Physiotherapy',30,23) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Cardiovascular Physiotherapy',40,23) RETURNING *;
--============================================================
 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Zaid','Ammar','1999-5-20','male','zaid@gmail.com','12369874','As-salt','9631486451',3, 11) RETURNING *

  INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/3768901/pexels-photo-3768901.jpeg?auto=compress&cs=tinysrgb&w=600','I am always proud of being part of recovering someones life and leading them to their full capacity of stregnth and independency step by step','-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in physio Joint center
',24) RETURNING *;

   INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Sports Physiotherapy',10,24) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Geriatric Physiotherapy',20,24) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Orthopedic Physiotherapy',15,24) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Pediatric Physiotherapy',35,24) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Neurological Physiotherapy',30,24) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Cardiovascular Physiotherapy',40,24) RETURNING *;
  --===========================================================

 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Marah','Khaled','1995-5-5','female','marah@gmail.com','12369874','Al-karak','9631486451',3,11) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://www.parker.edu/wp-content/uploads/2020/06/Parker-University_Chiropractic-Career.jpg','I am always proud of being part of recovering someones life and leading them to their full capacity of stregnth and independency step by step 
','-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in physio Joint center
',25) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Sports Physiotherapy',10,25) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Geriatric Physiotherapy',20,25) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Orthopedic Physiotherapy',15,25) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Pediatric Physiotherapy',35,25) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Neurological Physiotherapy',30,25) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Cardiovascular Physiotherapy',40,25) RETURNING *;
--==============================================================
 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Sabreen','Mohamad','2000-9-20','female','sabren@gmail.com','12369874','Jarash','9631486451',3,11) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://thecloisters.co.uk/wp-content/uploads/2022/10/shutterstock_1926782012-1-1536x1024.jpg','I am always proud of being part of recovering someones life and leading them to their full capacity of stregnth and independency step by step 
','-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in physio Joint center
',26) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Sports Physiotherapy',10,26) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Geriatric Physiotherapy',20,26) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Orthopedic Physiotherapy',15,26) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Pediatric Physiotherapy',35,26) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Neurological Physiotherapy',30,26) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Cardiovascular Physiotherapy',40,26) RETURNING *;
--========================	Occupational Therapy ===================
	
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Amal','Gazi','2000-9-20','female','amal@gmail.com','12369874','Az-zarqa','9631486451',3, 12) RETURNING *


INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/7176317/pexels-photo-7176317.jpeg?auto=compress&cs=tinysrgb&w=600','I am always proud of being part of recovering someones life and leading them to their independency in activities of daily living step by step 
 ','-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in Jordan Specialized Center For Autism center
',27) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('working at a job',25,27) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting together with friends',20,27) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('taking a class, cooking a meal',15,27) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting dressed, playing a sport',35,27) RETURNING *;
 
--===============================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Afnan','Mohamad','2000-2-20','female','afnan@gmail.com','12369874','Amman','9631486451',3, 12) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://www.therapyland.net/content/uploads/2023/02/occupational-therapy.jpg','I am always proud of being part of recovering someones life and leading them to their independency in activities of daily living step by step 
 ','-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in Jordan Specialized Center For Autism center
',28) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('working at a job',25,28) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting together with friends',20,28) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('taking a class, cooking a meal',15,28) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting dressed, playing a sport',35,28) RETURNING *;
--============================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Aya','Abdulhaq','1997-7-20','female','aya@gmail.com','12369874','Mafraq','9631486451',3, 12) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://www.nystromcounseling.com/wp-content/uploads/occupational-therapist-w-child.jpg','I am always proud of being part of recovering someones life and leading them to their independency in activities of daily living step by step 
 ','-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in Jordan Specialized Center For Autism center
',29) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('working at a job',25,29) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting together with friends',20,29) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('taking a class, cooking a meal',15,29) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting dressed, playing a sport',35,29) RETURNING *;
--==========================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Mutaz','Mansour','1992-9-20','male','mutaz@gmail.com','12369874','Jarash','9631486451',3, 12) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://i0.wp.com/post.healthline.com/wp-content/uploads/2020/03/senior-man-lift-a-dumbbell-he-doing-treatment-exercise-with-his-physiotherapist-1296x728-header.jpg?w=1155&h=1528','I am always proud of being part of recovering someones life and leading them to their independency in activities of daily living step by step 
 ','-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in Jordan Specialized Center For Autism center
',30) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('working at a job',25,30) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting together with friends',20,30) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('taking a class, cooking a meal',15,30) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting dressed, playing a sport',35,30) RETURNING *;
--===============================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Wael','Hakem','1996-9-20','male','wael@gmail.com','12369874','Ajlone','9631486451',3, 12) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoCJb1ozycLhIta5lOXijDVI4NxhvrWPmgKw&usqp=CAU','I am always proud of being part of recovering someones life and leading them to their independency in activities of daily living step by step 
 ','-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in Jordan Specialized Center For Autism center
',31) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('working at a job',25,31) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting together with friends',20,31) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('taking a class, cooking a meal',15,31) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting dressed, playing a sport',35,31) RETURNING *;
--============================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Adel','Gazi','2000-9-20','male','adel@gmail.com','12369874','Amman','9631486451',3, 12) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgBhFf9a3H8AeUrNPIMvTm0xXwyBgLY6EX2g&usqp=CAU','I am always proud of being part of recovering someones life and leading them to their independency in activities of daily living step by step 
 ','-Bachelors in Physiotherapy from University Of Jordan
- 1 year of experience in Jordan Specialized Center For Autism center
',32) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('working at a job',25,32) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting together with friends',20,32) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('taking a class, cooking a meal',15,32) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('getting dressed, playing a sport',35,32) RETURNING *;
--========================	Speech Therapy =================================

INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Ahmed','Hejazi','1996-6-2','male','ahmed11@gmail.com','12369874','Az-zarqa','9631486451',3, 13) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://res.cloudinary.com/drzcyo3sv/image/upload/v1697111941/iStock-848262700-1_iphdhw.jpg','I am always proud of being part of recovering someones life and leading them to expressing themselves and comunicate step by step','-Bachelors in Speech and Auditory Sciences from University Of Jordan',33) RETURNING *;

 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Perception exercises, for example to differentiate between individual sounds and syllables.',25,33) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to produce certain sounds and improve the fluency of speech.',20,33) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to improve breathing, swallowing and the voice',15,33) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('facilitate a learners use of natural gestures by providing communication opportunities while playing with a child on a structured learning task',35,33) RETURNING *;
--================================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Alia','Yousef','2000-2-15','female','Alia@gmail.com','12369874','Az-zarqa','9631486451',3, 13) RETURNING *
INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLwAiemY04_nGrwh-au8dtvtLvbUSL9pua_A&usqp=CAU','I am always proud of being part of recovering someones life and leading them to expressing themselves and comunicate step by step','-Bachelors in Speech and Auditory Sciences from University Of Jordan',34) RETURNING *;


 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Perception exercises, for example to differentiate between individual sounds and syllables.',25,34) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to produce certain sounds and improve the fluency of speech.',20,34) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to improve breathing, swallowing and the voice',15,34) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('facilitate a learners use of natural gestures by providing communication opportunities while playing with a child on a structured learning task',35,34) RETURNING *;
--====================================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Omar','Nafeth','1996-6-2','male','omer@gmail.com','12369874','Amman','9631486451',3, 13) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSa63fnKN7s0-ks_vokghb2_v89rrz1KJ47G7dKLWuxt7hwp41CXJHv8FBeM-NC2HzbRco&usqp=CAU','I am always proud of being part of recovering someones life and leading them to expressing themselves and comunicate step by step','-Bachelors in Speech and Auditory Sciences from University Of Jordan',35) RETURNING *;


 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Perception exercises, for example to differentiate between individual sounds and syllables.',25,35) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to produce certain sounds and improve the fluency of speech.',20,35) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to improve breathing, swallowing and the voice',15,35) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('facilitate a learners use of natural gestures by providing communication opportunities while playing with a child on a structured learning task',35,35) RETURNING *;
--===================================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Subhi','Hamed','1996-6-30','male','subhi@gmail.com','12369874','As-salt','9631486451',3,13) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('','I am always proud of being part of recovering someones life and leading them to expressing themselves and comunicate step by step','-Bachelors in Speech and Auditory Sciences from University Of Jordan',36) RETURNING *;


 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Perception exercises, for example to differentiate between individual sounds and syllables.',25,36) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to produce certain sounds and improve the fluency of speech.',20,36) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to improve breathing, swallowing and the voice',15,36) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('facilitate a learners use of natural gestures by providing communication opportunities while playing with a child on a structured learning task',35,36) RETURNING *;
--======================================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Sara','Abdullah','1996-6-2','female','sara@gmail.com','12369874','Amman','9631486451',3,13) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyEpa4JdahRbJxYnOerI-B-CmJHH6f7wXXQg&usqp=CAU','I am always proud of being part of recovering someones life and leading them to expressing themselves and comunicate step by step','-Bachelors in Speech and Auditory Sciences from University Of Jordan',37) RETURNING *;


 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Perception exercises, for example to differentiate between individual sounds and syllables.',25,37) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to produce certain sounds and improve the fluency of speech.',20,37) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to improve breathing, swallowing and the voice',15,37) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('facilitate a learners use of natural gestures by providing communication opportunities while playing with a child on a structured learning task',35,37) RETURNING *;
--===================================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Amera','Adel','2001-6-2','female','amera@gmail.com','12369874','Ajlone','9631486451',3,13) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('','I am always proud of being part of recovering someones life and leading them to expressing themselves and comunicate step by step','-Bachelors in Speech and Auditory Sciences from University Of Jordan',38) RETURNING *;


 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Perception exercises, for example to differentiate between individual sounds and syllables.',25,38) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to produce certain sounds and improve the fluency of speech.',20,38) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('Exercises to improve breathing, swallowing and the voice',15,38) RETURNING *;
  INSERT INTO services (service,price_per_hour,provider_id) VALUES ('facilitate a learners use of natural gestures by providing communication opportunities while playing with a child on a structured learning task',35,38) RETURNING *;
--========================= Babysitting =============================
 INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Malak','Mohamad','1996-6-2','female','malak@gmail.com','12369874','Amman','9631486451',3,14) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/755049/pexels-photo-755049.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1','Loving children is not enough for raising them , we need to understand them,their exploratory thoughts and behaviors and offcourse their needs 
 ','Bachelors in Education / Early Childhood Education from Al-Balqaa Applied University',40) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Day Babysitting',25,40) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Night Babysitting',40,40) RETURNING *;
INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
OverNight Babysitting',50,40) RETURNING *;
--===============================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Ghofran','Mamoun','2000-6-2','female','ghofran@gmail.com','12369874','Az-zarqa','9631486451',3, 14) RETURNING *


INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://images.pexels.com/photos/8504299/pexels-photo-8504299.jpeg?auto=compress&cs=tinysrgb&w=600','Loving children is not enough for raising them , we need to understand them,their exploratory thoughts and behaviors and offcourse their needs 
 ','Bachelors in Education / Early Childhood Education from Al-Balqaa Applied University',41) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Day Babysitting',25,41) RETURNING *;
 INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
Night Babysitting',40,41) RETURNING *;
INSERT INTO services (service,price_per_hour,provider_id) VALUES ('
OverNight Babysitting',50,41) RETURNING *;

--==========================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Alaa','Salem','1995-2-2','female','alaa@gmail.com','12369874','As-salt','9631486451',3, 14) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://www.unicef.org/jordan/sites/unicef.org.jordan/files/styles/media_large_image/public/MicrosoftTeams-image%20%281%29_4.png?itok=iI1t9FGG','Loving children is not enough for raising them , we need to understand them,their exploratory thoughts and behaviors and offcourse their needs 
 ','Bachelors in Education / Early Childhood Education from Al-Balqaa Applied University',42) RETURNING *;
--======================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Ayat','Mohamad','2000-7-2','female','ayat@gmail.com','12369874','Ajlone','9631486451',3, 14) RETURNING *
INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://cdnewmums.expatwoman.com/s3fs-public/styles/width_429/public/dubari.jpg?itok=AektvAJf','Loving children is not enough for raising them , we need to understand them,their exploratory thoughts and behaviors and offcourse their needs 
 ','Bachelors in Education / Early Childhood Education from Al-Balqaa Applied University',43) RETURNING *

--=======================================================
INSERT INTO providers  (fname,
  lname,
  birthdate,
  gender,
  email,
  password,
  city,
  phonenumber,
  role_id,
  category_id) VALUES('Manar','Ali','1999-4-2','female','mnar@gmail.com','12369874','Mafraq','9631486451',3, 14) RETURNING *

INSERT INTO provider_info  (img,bio,qualifications, provider_id) VALUES ('https://www-static.apta-advice.com/wp-content/uploads/2018/03/31-Baby-development-Month-11.jpg','Loving children is not enough for raising them , we need to understand them,their exploratory thoughts and behaviors and offcourse their needs 
 ','Bachelors in Education / Early Childhood Education from Al-Balqaa Applied University',44) RETURNING *;



--====================== ROLE & permition ===============================

INSERT INTO roles (role) VALUES ('admin') RETURNING *

INSERT INTO permissions (permission) VALUES ('ADD_CATEGORY') RETURNING *;
INSERT INTO permissions (permission) VALUES ('DELETE_PROVIDER') RETURNING *;
INSERT INTO permissions (permission) VALUES ('SHOW_ADMIN_PANEL') RETURNING *;



INSERT INTO roles (role) VALUES ('user') RETURNING *

INSERT INTO permissions (permission) VALUES ('ADD_ORDER') RETURNING *;
INSERT INTO permissions (permission) VALUES ('ADD_HISTORY') RETURNING *;
INSERT INTO permissions (permission) VALUES ('DELETE_HISTORY') RETURNING *;



INSERT INTO roles (role) VALUES ('provider') RETURNING *

INSERT INTO permissions (permission) VALUES ('ADD_NOTE') RETURNING *;
INSERT INTO permissions (permission) VALUES ('ADD_SERVICE') RETURNING *;
INSERT INTO permissions (permission) VALUES ('ADD_SCHDEUAL') RETURNING *;








-- psql -U postgres -f ./models/database.sql