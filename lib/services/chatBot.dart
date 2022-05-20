import 'dart:math';


class ChatBot{
  Random random = new Random();

  Map<String,List> queryResponses={
    "open sign chat":["opening sign chat"],
    "open chat":["opening sign chat"],
    "sign chat":["opening sign chat"],
    "open sign":["opening sign chat"],
    "chat":["opening sign chat"],
    "open audio navigation":["opening audio navigation"],
    "audio navigation":["opening audio navigation"],
    "open audio":["opening audio navigation"],
    "audio":["opening audio navigation"],
    "open voice assign":["opening voice assign"],
    "voice assign":["opening voice assign"],
    "voice":["opening voice assign"],
    "open learn":["opening learn"],
    "learn":["opening learn"],
    "hello" : ["Hello","Hi there, how can I help?","Good to see you again","Hi it is good to see you"],
    "hi" : ["Hello","Hi there, how can I help?","Good to see you again","Hi it is good to see you"],
    "hi how are you" : ["Hello","Hi there, how can I help?","Good to see you again","i'm pretty good. thanks for asking","Hi it is good to see you"],
    "halo" : ["Hello","Hi there, how can I help?","i'm pretty good. thanks for asking.","Good to see you again","Hi it is good to see you"],
    "how do you do" : ["Hello","Hi there, how can I help?","Good to see you again","Hi it is good to see you"],
    "whats up" : ["Hello","i'm pretty good. thanks for asking.","Hi it is good to see you","Hi there, how can I help?","Good to see you again"],
    "cya" : ["good bye","good bye and see you later","Thanks for your time and see you"],
    "see you" : ["good bye","good bye and see you later","Thanks for your time and see you"],
    "goodbye" : ["good bye","good bye and see you later","Thanks for your time and see you"],
    "good bye" : ["good bye","good bye and see you later","Thanks for your time and see you"],
    "bye" : ["good bye","good bye and see you later","Thanks for your time and see you"],
    "see you later" : ["good bye","good bye and see you later","Thanks for your time and see you","Have a good day"],
    "haloi" : ["Hello","Hi there, how can I help?","Good to see you again"],
    "what you do" :  ["I am there to assist you","I wish i can help you","I will be a sole companion for you"],
    "what do you do" : ["I am there to assist you","I wish i can help you","I will be a sole companion for you"],
    "what is your work" : ["I am there to assist you","I wish i can help you","I will be a sole companion for you"],
    "what is your job" : ["I am there to assist you","I wish i can help you","I will be a sole companion for you"],
    "who is your creator":["I was created by team UEC"],
    "when did you born":["It is on 2022"],
    "wow do you know me":["I am your assistant and i knows you"],
    "who is your owner":["Right now it is the person who possess the device"],
    "so how have you been":	["i've been great. what about you?"],
    "how is it going":	["i'm doing well. how about you?"],
    "so how have you been lately":	["i've actually been pretty good."],
    "how are you doing today":["i'm doing great. what about you?"],
    "i think it may rain" :	["it's the middle of summer, it shouldn't rain today. that would be weird."],
    "it doesn't look very nice outside today.":["	you're right. i think it's going to rain later."],
    "it is such a nice day.":["	yes, it is."],
    "it looks like it may rain soon.":["	yes, and i hope that it does."],
    "what are the features of this app":["It help you to chat with dumb,deaf and partially blind users, learn signs"],
    "ok":["thank you for your time and patience , have a nice day","is there anything you want to know more ??"],
    "no":["thank you"],
    "who are you":["i am your assistant"],
    "how many languages do you know":["I only know english in which i was developed for"],
    "how many language do you know":["I only know english in which i was developed for"],
    "what shit are you":["😵‍💫 Oops! Sorry, I didn't understand your question."],
    "what the hell is going on":["😵‍💫 Oops! Sorry, I didn't understand your question."],
    "are you dumb":["I’m sorry I am here to help you"],
    "can you help me":["Sure it is my only intention"],
    "do you know who I am":["I think you are the owner of this device"],
    "will you be available all time":["I will be available every moment for your needs"],
    "where do you live":["I live just here"],
    "where are you":["I live just here"],
    "when do you wake up":["I am always here"],

};

  String? chat({required String queryAsked}){
    for(String query in queryResponses.keys){
      if(queryAsked==query){
        print(random.nextInt(queryResponses[query]!.length));
        return queryResponses[query]![random.nextInt(queryResponses[query]!.length)];
      }
    }
    return "Sorry I could not understand";
  }
}