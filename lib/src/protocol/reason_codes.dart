// Default server reason codes
class ReasonCodes {
  /// General error
  static const int generalError = 1;

  /// General session error
  static const int sessionError = 11;

  /// The session resource is already registered
  static const int sessionRegistrationError = 12;

  /// An authentication error occurred
  static const int sessionAuthenticationFailed = 13;

  /// An error occurred while unregistering the session in the server
  static const int sessionUnregisterFailed = 14;

  /// The required action is invalid for current session state
  static const int sessionInvalidActionForState = 15;

  /// The session negotiation has timed out
  static const int sessionNegotiationTimeout = 16;

  /// Invalid selected negotiation options
  static const int sessionNegotiationInvalidOptions = 17;

  /// Invalid session mode requested
  static const int sessionInvalidSessionModeRequested = 18;

  /// General validation error
  static const int validationError = 21;

  /// The envelope document is null
  static const int validationEmptyDocument = 22;

  /// The envelope document MIME type is invalid
  static const int validationInvalidResource = 23;

  /// The request status is invalid
  static const int validationInvalidStatus = 24;

  /// The request identity is invalid
  static const int validationInvalidIdentity = 25;

  /// The envelope originator or destination is invalid
  static const int validationInvalidRecipients = 26;

  /// The command method is invalid
  static const int validationInvalidMethod = 27;

  /// The command URI format is invalid
  static const int validationInvalidUri = 27;

  /// General authorization error
  static const int authorizationError = 31;

  /// The sender is not authorized to send messages to the message destination
  static const int authorizationUnauthorizedSender = 32;

  /// The destination doesn't have an active account
  static const int authorizationDestinationAccountNotFound = 33;

  /// The envelope quota limit has been exceeded
  static const int authorizationQuotaThresholdExceeded = 34;

  /// General routing error
  static const int routingError = 41;

  /// The message destination was not found
  static const int routingDestinationNotFound = 42;

  /// The message destination gateway was not found
  static const int routingGatewayNotFound = 43;

  /// The message destination was not found
  static const int routingRouteNotFound = 44;

  /// General dispatching error
  static const int dispatchError = 51;

  /// General command processing error
  static const int commandProcessingError = 61;

  /// There's no command processor available for process the request
  static const int commandResourceNotSupported = 62;

  /// The command method is not supported
  static const int commandMethodNotSupported = 63;

  /// The command method has an invalid argument value
  static const int commandInvalidArgument = 64;

  /// The requested command is not valid for current session mode
  static const int commandInvalidSessionMode = 65;

  /// The command method was not allowed
  static const int commandNotAllowed = 66;

  /// The command resource was not found
  static const int commandResourceNotFound = 67;

  /// General message processing error
  static const int messageProcessingError = 61;

  /// The message content type is not supported
  static const int messageUnsupportedContentType = 71;

  /// General gateway processing error
  static const int gatewayError = 81;

  /// The content type is not supported by the gateway
  static const int gatewayContentTypeNotSupported = 82;

  /// The message destination was not found on gateway
  static const int gatewayDestinationNotFound = 83;

  /// The functionality is not supported by the gateway
  static const int gatewayNotSupported = 84;

  /// General application processing error
  static const int applicationError = 10;
}
