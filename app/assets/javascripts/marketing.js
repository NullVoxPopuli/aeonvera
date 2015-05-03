$(function(){
  var serviceFee = $("#serviceFee");
  var cardFee = $("#cardFee");
  var buyerPays = $("#buyerPays");
  var youGet = $("#youGet")
  var ticketPrice = $("#ticketPrice");
  var absorbFees = $("#absorbFees");

  function reCalculate( value ){
    var value = typeof value !== 'undefined' ? value : parseFloat(ticketPrice.val());
    serviceFeeValue = 0;
    cardFeeValue = 0;
    buyerPaysValue = 0;
    youGetValue = 0;

    if (absorbFees.is(':checked')){
      serviceFeeValue = value * 0.0075
      cardFeeValue = value * 0.029 + 0.3
      buyerPaysValue = value;
      youGetValue = buyerPaysValue - serviceFeeValue - cardFeeValue
    } else {
      youGetValue = value
      buyerPaysValue = (
        (youGetValue + 0.3) / (1 - (0.029 + 0.0075))
      )

      serviceFeeValue = buyerPaysValue * 0.0075
      cardFeeValue = buyerPaysValue * 0.029 + 0.3
    }

    serviceFee.html(serviceFeeValue.toFixed(2));
    cardFee.html(cardFeeValue.toFixed(2));
    buyerPays.html(buyerPaysValue.toFixed(2));
    youGet.html(youGetValue.toFixed(2));
  }

  ticketPrice.on('change input paste keyup', function(){
    reCalculate();
  });

  absorbFees.on('change', function(){
    reCalculate();
  });

  reCalculate(75);
});