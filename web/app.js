import {loadStripe} from '@stripe/stripe-js';
var stripe = await loadStripe('pk_test_TYooMQauvdEDq54NiTphI7jx');

function payWithApplePay() {
  var paymentRequest = {
    countryCode: 'US',
    currencyCode: 'USD',
    total: {
      label: 'DoggoBox',
      amount: '24.99'
    }
  };

  stripe.applePay.checkAvailability(function (available) {
    if (available) {
      var session = Stripe.applePay.buildSession(paymentRequest,
        function(result, completion) {
    
        $.post('/charges', { token: result.token.id }).done(function() {
          completion(ApplePaySession.STATUS_SUCCESS);
          // You can now redirect the user to a receipt page, etc.
          window.location.href = '/success.html';
        }).fail(function() {
          completion(ApplePaySession.STATUS_FAILURE);
        });
    
      }, function(error) {
        console.log(error.message);
      });
    
      session.oncancel = function() {
        console.log("User hit the cancel button in the payment window");
      };
    
      session.begin();
    } else {
      console.log("Apple Pay is not supported on this browser");
    }
  });


}
