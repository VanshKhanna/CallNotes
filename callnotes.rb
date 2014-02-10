require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'stringio'
require 'stringio'
require 'forwardable'

post '/transcribenew' do
account_sid = 'twilio account sid goes here'
auth_token = 'twilio auth token goes here'
@client = Twilio::REST::Client.new account_sid, auth_token
@transcription = @client.account.transcriptions.get(params['TranscriptionSid'])

puts @transcription.transcription_text
str = @transcription.transcription_text

temp= Array.new
words= str.split(" ")
i=0

for num in 0...words.length

if words[num] == "is" && num <= words.length-3 && words[i+1] > '9'

    #if words[i+1] > '9'
        temp[i] = "Name:"
        i = i+1
        temp[i] = words[num+1]
    	i = i + 1
    	temp[i] = words[num+2]
    	i = i + 1

elsif words[num] == "is" && words[i+1] >= '0' && words[i+1] <= '9'
        temp[i] = "Number:"
        i = i+1
=begin
	temp[i] = "Name:"
	i = i + 1
	temp[i] = words[num+1]
	i = i + 1
	temp[i] = words[num+2]
	i = i + 1

    elsif words[num] == "number" && num <= words.length-3
	temp[i] = "Number:"
	i = i+1
=end

elsif words[num] == "at"
	temp[i] = "at"
	i = i + 1

elsif words[num] == "calling"
    temp[i] = "Number"
    i = i+1

elsif words[num] >= '0' && words[num] <='9'
	temp[i] = words[num]
	i = i + 1
    end
end

print temp

# concatenation code below

st=temp[0]
for v in 1...temp.length
	if temp[v]>='0' && temp[v]<='9' && temp[v-1]>'9'
		st= st+' '+temp[v]
	else if temp[v]>'9' && temp[v]>='0' && temp[v-1]<='9'
    	st= st+' '+temp[v]

	else if temp[v]>'9' && temp[v-1] > '9'
		st = st + ' ' + temp[v]
	else
		st= st+temp[v]
	end
end
end
end

print st

# Sending parsed text below

@client.account.messages.create(
:from => 'your twilio number',
:to => 'your non-twilio phone number',
:body => st)

end

get '/hello-monkey' do

Twilio::TwiML::Response.new do |r|
r.Say "Hello, please leave me a message with your full name and phone number."

r.Gather :numDigits => '1', :action => '/hello-monkey/handle-gather', :method => 'get' do |g|
g.Say 'To leave a message, press 2.'
	 end
	end.text
	end
get '/hello-monkey/handle-gather' do
	redirect '/hello-monkey' unless ['1', '2'].include?(params['Digits'])
	if params['Digits'] == '1'
		response = Twilio::TwiML::Response.new do |r|
		r.Say 'Goodbye.'
	end
	elsif params['Digits'] == '2'
		response = Twilio::TwiML::Response.new do |r|
		r.Say 'Record your message after the tone.'
		r.Record :maxLength => '119', :action => '/hello-monkey/handle-record', :method => 'get',:transcribe => 'true', :transcribeCallback => '/transcribenew'

	end
end
response.text
end

get '/hello-monkey/handle-record' do
resp = Twilio::TwiML::Response.new do |r|
r.Say 'Listen to your message.'
r.Play params['RecordingUrl']
r.Say 'Goodbye.'
end
resp.text
end
