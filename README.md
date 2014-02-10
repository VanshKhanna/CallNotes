CallNotes
=========

1. To run at the command: ruby callnotes.rb
   
   Let's use an ngrok web server, which can be downloaded at https://ngrok.com/.

2. After the above command, launch the server with the command: ./ngrok 4567

Never note down another phone number again! This Ruby script uses the Twilio API and allows you to receive texts from voicemails. 
The script creates a transcript of the voice message and parses it into a text message. The text contains the name of the person 
and his/her phone number, so you don't need to retrieve contact information from voicemails manually.

If someone calls your Twilio number, they can leave a voice message which is sent as a text to your actual (non-Twilio) number.


Project created at BoilerMake, a hackathon at Purdue University on February 7-9, 2014 in collaboration with my teammate Vansh Khanna (kvansh12@gmail.com). The ChallengePost submission page is at http://boilermake.challengepost.com/submissions/20632-callnotes.

Sample voice message: "My name is John Smith and my number is 1234567890."
Received text: "Name: John Smith 123-456-7890."
