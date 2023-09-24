/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM `Facilities`
WHERE membercost = 0.0


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(name)
FROM `Facilities`
WHERE membercost = 0.0

（4）


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM `Facilities`
WHERE membercost != 0
    AND membercost < monthlymaintenance * 0.2;


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid IN (1, 5)


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT
	name,
	monthlymaintenance,
    CASE WHEN monthlymaintenance > 100 THEN 'expensive'
    	 ELSE 'cheap' END AS maintenance_tier
FROM Facilities


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

-- THE QUESTION IS WORDED AMBIGUOUSLY, AS THE (S) AFTER 'MEMBER' IMPLIES
-- THAT THE ANSWER MAY CONTAIN MORE THAN ONE NAME, WHICH IS A LOGICAL
-- CONTRADICTION WITH THE PHRASE 'LAST MEMBER.'

-- TO ADDRESS THIS, I HAVE WRITTEN TWO DIFFERENT QUERIES. THE FIRST RETURNS
-- THE TRUE LAST PERSON TO SIGN UP (ONE RECORD ONLY, UNLESS TWO RECORDS HAVE
-- EXACTLY THE SAME TIME, DOWN TO THE SECOND):

SELECT firstname, surname
FROM `Members`
WHERE joindate = (SELECT MAX(joindate) FROM Members)

-- THE SECOND RETURNS ALL MEMBERS WHO SIGNED UP ON THE MOST RECENT DAY OF
-- RECORDS, ORDERED DESCENDING (SO THE MOST RECENT IS AT THE TOP). HOWEVER,
-- THE RESULT OF THIS QUERY IS THE SAME AS ABOVE; ONLY ONE PERSON SIGNED UP
-- ON THE MOST RECENT DAY OF RECORDS.

SELECT
	firstname,
    surname
FROM `Members`
WHERE DATE(joindate) = (SELECT MAX(DATE(joindate)) FROM Members)
ORDER BY joindate DESC


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

-- AGAIN, THE QUESTION IS AMBIGUOUS. DO YOU WANT ONLY UNIQUE NAMES? OR ONLY
-- UNIQUE COURT/NAME PAIRINGS? THE FIRST WOULD MAKE THE MOST BUSINESS SENSE,
-- BUT THE QUESTION ALSO ASKS FOR THE COURT NAME TO BE INCLUDED, WHICH MAKES
-- NO SENSE; SINCE MANY MEMBERS HAVE USED MULTIPLE COURTS, ONLY SELECTING
-- DISTINCT MEMBER NAMES WOULD RETURN AN ESSENTIALLY RANDOM COURT NAME NEXT
-- TO EACH MEMBER. WHAT WOULD THE POINT OF THIS BE?

-- TO ADDRESS THIS, I'VE WRITTEN TWO QUERIES. THIS FIRST ONE PRODUCES ONLY
-- UNIQUE COURT/MEMBER NAME PAIRS：

SELECT DISTINCT
    f.name AS court,
    CONCAT(m.firstname, ' ', m.surname) AS member
FROM Bookings AS b
LEFT JOIN Facilities AS f ON b.facid = f.facid
LEFT JOIN Members AS m ON b.memid = m.memid
WHERE m.firstname != 'GUEST'
    AND f.name LIKE 'Tennis%'
ORDER BY member

-- THE NEXT ONE PRODUCES ONLY UNQIUE MEMBER NAMES （AS SEEMS TO BE IMPLIED
-- BY 'PRODUCE A LIST OF ALL MEMBERS WHO HAVE USED A TENNIS COURT'). AS
-- YOU CAN SEE, THE NAME OF THE COURT HERE IS MEANINGLESS INFORMATION,
-- SINCE THESE MEMBERS MAY HAVE BOOKED MORE THAN ONE COURT IN THE PAST, BUT
-- ONLY ONE COURT NAME IS RETURNED. IT WOULD BE EASY FOR SOMEONE TO
-- MISINTERPRET THIS DATA; I DO NOT RECOMMEND USING THIS TABLE FOR ANYTHING.
-- A BETTER SOLUTION WOULD BE TO OMIT THE COURT NAME.

SELECT
    MAX(f.name) AS court,
    CONCAT(m.firstname, ' ', m.surname) AS member
FROM Bookings AS b
LEFT JOIN Facilities AS f ON b.facid = f.facid
LEFT JOIN Members AS m ON b.memid = m.memid
WHERE m.firstname != 'GUEST'
    AND f.name LIKE 'Tennis%'
GROUP BY member
ORDER BY member


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT
	f.name AS facility,
    CASE WHEN m.surname = 'GUEST' THEN 'GUEST'
    	ELSE CONCAT(m.firstname, ' ', m.surname) END AS member,
    CASE WHEN m.surname = 'GUEST' THEN f.guestcost * b.slots
    	ELSE f.membercost * b.slots END AS cost
FROM Bookings AS b
LEFT JOIN Facilities AS f ON b.facid = f.facid
LEFT JOIN Members AS m ON b.memid = m.memid
WHERE DATE(b.starttime) = '2012-09-14'
	AND ((m.surname = 'GUEST' AND f.guestcost * b.slots > 30)
    OR (m.surname != 'GUEST' AND f.membercost * b.slots > 30))
ORDER BY cost DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT
	f.name AS facility,
    CASE WHEN m.surname = 'GUEST' THEN 'GUEST'
    	ELSE CONCAT(m.firstname, ' ', m.surname) END AS member,
    CASE WHEN m.surname = 'GUEST' THEN f.guestcost * b.slots
    	ELSE f.membercost * b.slots END AS cost
FROM (
    SELECT facid, memid, slots 
    FROM Bookings
    WHERE DATE(starttime) = '2012-09-14'
    ) AS b
LEFT JOIN Facilities AS f ON b.facid = f.facid
LEFT JOIN Members AS m ON b.memid = m.memid
WHERE (m.surname = 'GUEST' AND f.guestcost * b.slots > 30)
    OR (m.surname != 'GUEST' AND f.membercost * b.slots > 30)
ORDER BY cost DESC


/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.


QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

"""
            
WITH booking_plus AS (
SELECT
    b.bookid,
    b.facid,
    b.memid,
    CASE WHEN m.surname = 'GUEST' THEN f.guestcost * b.slots
        ELSE f.membercost * b.slots END AS booking_revenue
    FROM Bookings AS b
    LEFT JOIN Facilities AS f ON b.facid = f.facid
    LEFT JOIN Members AS m ON b.memid = m.memid
)

SELECT 
    f.name,
    SUM(booking_revenue) AS revenue
FROM booking_plus AS b
LEFT JOIN Facilities AS f ON b.facid = f.facid
GROUP BY f.name
HAVING SUM(booking_revenue) < 1000
ORDER BY revenue
            
"""

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

"""
                   
WITH members_only AS (
    SELECT
        firstname,
        surname,
        recommendedby,
        memid
    FROM members
    WHERE firstname != 'Guest'
)

SELECT
    m1.surname,
    m1.firstname,
    m2.firstname||' '||m2.surname AS recommender
FROM members_only AS m1
LEFT JOIN members_only AS m2 ON m1.recommendedby = m2.memid
ORDER BY m1.surname, m1.firstname

"""

/* Q12: Find the facilities with their usage by member, but not guests */

"""
            
WITH member_bookings AS (
    SELECT
        facid,
        memid,
        slots
    FROM Bookings
    WHERE memid != 0
)

SELECT
    f.name AS facility,
    m.firstname||' '||m.surname AS member,
    SUM(b.slots) AS member_usage
FROM member_bookings AS b
LEFT JOIN Facilities AS f ON b.facid = f.facid
LEFT JOIN Members AS m ON b.memid = m.memid
GROUP BY facility, member
            
"""


/* Q13: Find the facilities usage by month, but not guests */

"""
                
WITH monthly_bookings AS (
    SELECT
        facid,
        slots,
        strftime('%Y', starttime)||'-'||strftime('%m', starttime) AS month
    FROM Bookings
    WHERE memid != 0
)

SELECT
    f.name AS facility,
    b.month,
    SUM(b.slots) AS member_usage
FROM monthly_bookings AS b
LEFT JOIN Facilities AS f ON b.facid = f.facid
GROUP BY facility, month
                
"""

