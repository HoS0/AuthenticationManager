amqp = require('AMQP-boilerplate')
Guid = require('guid')

name = 'authenticationmanager'
DataManager = 'datamanager'

console.log "------------ " + name + " - " + "has started"

amqp.Initialize name, () ->
    amqp.CreateRequestQueue name, (message) ->
        parseMessage message

SendFailResponceBack = (message, reason) ->
    if message.responceNeeded
        message.error = reason
        message.responceNeeded = false
        if message.sender
            amqp.SendMessage message.sender, message    

createAction = (message) ->
    sender = message.sender
    recieverMessageId = message.id
    amqp.Log "info", "request for create from " + message.sender, ""    
    amqp.SendMessage DataManager, message, (res) -> ### create ###

retrieveAction = (message) ->
    sender = message.sender
    recieverMessageId = message.id
    amqp.Log "info", "request for retrieve from " + message.sender, ""
    message.responceNeeded = true
    amqp.SendMessage DataManager, message, (res) -> ### get ###

parseMessage = (message) ->
    switch message.action
        when 'create' then createAction message
        when 'retrieve' then retrieveAction message
        else SendFailResponceBack message, "action found."