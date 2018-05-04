

class AlexaController < ApplicationController

  skip_before_action :verify_authenticity_token
  
  #
  #  beckman dashboard - remove this
  # 
  def index

    if params['request']     
      case params['request']['type']
      when 'LaunchRequest'
        response = launch_request_response('BeckmanDashboard', "Welcome to the Beckman dashboard!", false)
      when 'IntentRequest'
        response = intent_request_response_beckman('BeckmanDashboard',params['request']['intent'])
      else
        response = {request: params['request']['type'],status: 'error request'}.to_json
      end
    else
      response = {request: params,status: 'error params'}.to_json
    end

    render json: response
    
  end
  
  #
  #  beckman dashboard - remove this
  #   
  def dashboard
    @intent = Alexa.last.intent       
    session[:last_intent] = @intent   
    render layout: 'dashboard'  
  end
  
  #
  #  beckman dashboard - remove this
  #   
  def dashboard_partial
    @intent = Alexa.last.intent if Alexa.last      
    session[:last_intent] = @intent
    render partial: 'dashboard'        
  end    

  def shopping
    begin
      if params['request']['type'] == 'LaunchRequest'
        response = launch_request_response("BlackberryList", "Welcome to the Blackberry Hill List!", false)
      elsif params['request']['type'] == 'IntentRequest'
        response = intent_request_response_shopping("BlackberryList",params['request']['intent'])
      else
        response = {request: params, status: 'unknown request'} 
      end      
    rescue StandardError => e
      response = {request: params, status: e}
    end
    
    render json: response
    
  end
  
  def tides
    begin
      if params['request']['type'] == 'LaunchRequest'
        response = launch_request_response("SantaCruzTides", Tides.get_santa_cruz_tides, true)
      else
        response = {request: params, status: 'unknown request'} 
      end      
    rescue StandardError => e
      response = {request: params, status: e}
    end
    
    render json: response
    
  end  

    
  
private

  def launch_request_response(skill, speech, stop_interaction)
    Alexa.create(skill: skill, request: 'LaunchRequest')
    { version: "1.0",
      response: {
        outputSpeech: {
          type: "PlainText",
          text: speech },
        shouldEndSession: stop_interaction ? "true" : "false" }
    }        
  end

  def intent_request_response_beckman( skill, intent )
      intent_name = intent['name']
      stop_interaction = false
      case intent_name
      when 'Overview'
        Alexa.create(skill: skill,intent: intent_name)
        speech = 'Here is the overview. You can ask to show turnaround time or sample volume, or to cancel.'
      when 'Turnaround'
        Alexa.create(skill: skill,intent: intent_name)
        speech = 'This shows turnaround time. Current turnaround time is 40 minutes.'
      when 'Samplevolume'
        Alexa.create(skill: skill,intent: intent_name)
        speech = 'This shows sample volume or throughput.'
      when 'AMAZON.HelpIntent'
        speech = 'You can say show overview, turnaroundtime, or sample volume.'
      when 'AMAZON.StopIntent'
        speech = 'Beckman dashboard, out.'
        stop_interaction = true
      when 'AMAZON.CancelIntent'
        speech = 'Beckman dashboard, out.'
        stop_interaction = true
      else
        speech = 'I did not understand that.'
      end
      Alexa.create(skill: skill, request: "IntentRequest", 
                   intent: intent_name, answer: speech ) 
        { version: "1.0",
          response: {
            outputSpeech: {
              type: "PlainText",
              text: speech },
            shouldEndSession: stop_interaction ? "true" : "false" }
        }             
  end

  def intent_request_response_shopping( skill, intent )
  
      intent_name = intent['name']
      intent_confirmed = intent['confirmationStatus']
      speech = 'Sorry, that did not work'
      speech += ' because blackberry hill does not exist' if !p
      stop_interaction = false
      confirm_clear = false      
            
      case intent_name
      when 'add'
        if ( @item = intent['slots']['Items']['value'] )        
          speech = 'Adding ' + @item + ' to the Blackberry Hill List'          
        end          
      when 'list'
        speech = 'Here is what is on the Blackberry Hill List : carrots' 
      when 'clear'
        if intent_confirmed == 'CONFIRMED'
          speech = 'Clearing Blackberry Hill List'
        elsif intent_confirmed == 'DENIED'
          speech = 'Ok, I will not touch the list'
        else
          confirm_clear = true
        end
      when 'AMAZON.HelpIntent'
        speech = 'You can add items, like: add eggs, and you can use list and clear as commands'
      when 'AMAZON.StopIntent'
        speech = 'Blackberry Hill List, out.'
        stop_interaction = true
      when 'AMAZON.CancelIntent'
        speech = 'Blackberry Hill List, out.'
        stop_interaction = true
      else
        speech = 'I did not understand that.'
      end
      Alexa.create(skill: skill, request: "IntentRequest", 
                   intent: intent_name, slot: @item, answer: speech )    
      
      #
      #  normal response (with stop interaction flag), or dialog delegation
      #
      if !confirm_clear
        { version: "1.0",
          response: {
            outputSpeech: {
              type: "PlainText",
              text: speech },
            shouldEndSession: stop_interaction ? "true" : "false" }
        }        
      else
        { version: "1.0",
          response: {
            directives: [
              {
                type: "Dialog.Delegate",
                updatedIntent: {
                  name: "clear",
                  slots: {}
                }
              }
            ],
            shouldEndSession: stop_interaction ? "true" : "false" }
        }        
      end
     
  end
  
end

=begin

Alexa skills beckman dashboard
{
    "interactionModel": {
        "languageModel": {
            "invocationName": "beckman dashboard",
            "intents": [
                {
                    "name": "AMAZON.CancelIntent",
                    "samples": [
                        "cancel"
                    ]
                },
                {
                    "name": "AMAZON.HelpIntent",
                    "samples": [
                        "help"
                    ]
                },
                {
                    "name": "AMAZON.StopIntent",
                    "samples": [
                        "exit",
                        "stop"
                    ]
                },
                {
                    "name": "Overview",
                    "slots": [],
                    "samples": [
                        "overview",
                        "show overview"
                    ]
                },
                {
                    "name": "Turnaround",
                    "slots": [],
                    "samples": [
                        "TTA",
                        "turn around time",
                        "turnaroundtime",
                        "show turnaround time",
                        "turnaround time"
                    ]
                },
                {
                    "name": "Samplevolume",
                    "slots": [],
                    "samples": [
                        "show sample volume",
                        "sample volume"
                    ]
                }
            ],
            "types": []
        }
    }
}

Alexa skills shopping

{
    "interactionModel": {
        "languageModel": {
            "invocationName": "blackberry hill",
            "intents": [
                {
                    "name": "AMAZON.CancelIntent",
                    "samples": [
                        "cancel"
                    ]
                },
                {
                    "name": "AMAZON.HelpIntent",
                    "samples": [
                        "help"
                    ]
                },
                {
                    "name": "AMAZON.StopIntent",
                    "samples": [
                        "exit",
                        "stop"
                    ]
                },
                {
                    "name": "list",
                    "slots": [],
                    "samples": [
                        "what is on it",
                        "show",
                        "show list",
                        "list"
                    ]
                },
                {
                    "name": "clear",
                    "slots": [],
                    "samples": [
                        "clear"
                    ]
                },
                {
                    "name": "add",
                    "slots": [
                        {
                            "name": "Items",
                            "type": "ITEMS"
                        }
                    ],
                    "samples": [
                        "add {Items}"
                    ]
                }
            ],
            "types": [
                {
                    "name": "ITEMS",
                    "values": [
                        {
                            "name": {
                                "value": "rasberries"
                            }
                        },
                        {
                            "name": {
                                "value": "salad"
                            }
                        },
                        {
                            "name": {
                                "value": "yogurt"
                            }
                        },
                        {
                            "name": {
                                "value": "grapes"
                            }
                        },
                        {
                            "name": {
                                "value": "juice"
                            }
                        },
                        {
                            "name": {
                                "value": "bread"
                            }
                        },
                        {
                            "name": {
                                "value": "eggs"
                            }
                        }
                    ]
                }
            ]
        },
        "dialog": {
            "intents": [
                {
                    "name": "clear",
                    "confirmationRequired": true,
                    "prompts": {/alexa/console/ask/build/custom/amzn1.ask.skill.57349468-e7fc-41e7-a3c0-2cbe4a21af1a/development/en_US/dashboard?
        },
        "prompts": [
            {
                "id": "Confirm.Intent.464198807244",
                "variations": [
                    {
                        "type": "PlainText",
                        "value": "sure?"
                    }
                ]
            },
            {
                "id": "Elicit.Slot.430506019446.142211545338",
                "variations": [
                    {
                        "type": "PlainText",
                        "value": "What did you want to add?"
                    }
                ]
            }
        ]
    }
}

=end




