# 2besafe

This is an assignment for COMP90018 Mobile Computing Systems Programming in the University of Melbourne.

2besafe aims at ensuring the user seek help immediately once him/her encounters the dangerous situation.

When the user thinks he/she is unsafe from one place to another, he/she may create a task. The user needs to set the destination and the expected arrival time. 2besafe will send notification emails to the user's friends if the user doesn't cancel the task within the time. The user can also shake the phone to call 000 as long as he/she meets danger.

2besafe consists of server and client. Backend and client are programmed in PHP and swift individually. Server deploys on Azure. MySQL is used as the database.

# Register Page

The user needs to register first

# Login Page

The user needs to login in the beginning.

# Home Page

There are 4 functionalities in the home page, namely New Task, My Contacts, Call 000 and Criminal Statistics.

# New Task Page

The user is able to create a task on this page. He/she search the destination on a map, and 2besafe provides a recommended arrival time for the user based on the current location and destination.

The user then needs to select an arrival time below. 2besafe aims at short distance travels. So only 5,10,15,...,60 minutes are provided.

Once the user starts the task, the Timer Page will display.

# Timer Page

There's a timer on the page to inform the user the remaining time. The user is able to shake the phone to call 000 as long as he/she meets danger. An alert will pop up in order to inform the user to stop the task before 2 minutes of the expected end time.

If the user doesn't cancel a task, an alert will show on the home page to inform the user.

# My Contact Page

The user is able to add and modify his/her emergency contact on this page. 2besafe allows 2 emergency contacts at most.

# Call 000

The user is able to click this button to call 000

# Criminal Statistics

2besafe provides a link to Victoria State's crime statistics. The user can check the related information around his/her area.
