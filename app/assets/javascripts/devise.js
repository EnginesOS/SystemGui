$(document).ready(function(){

    if (document.getElementsByClassName("devise-view")) {
      $(".devise-view input[name!='commit'][type!='checkbox']").each( function(){
          $(this).addClass("form-control input-lg");
      });
      $(".devise-view button[name='commit']").each( function(){
          $(this).addClass("btn btn-primary btn-lg top-gap trigger-response-modal");
      });
      $(".devise-view input[name='commit']").each( function(){
          $(this).addClass("btn btn-primary btn-lg top-gap trigger-response-modal");
      });
      $(".devise-view label").each( function(){
          $(this).parent().addClass("top-gap");
      });
      $(".devise-view a").each( function(){
          $(this).addClass("btn btn-default top-gap trigger-response-modal");
      });

    };
});

