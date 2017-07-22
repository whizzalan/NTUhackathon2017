$(document).ready(function() {
    $('.nav.navbar-nav').remove();
    $('.navbar-default').attr('style',"background-color: black;margin-bottom: 0px;");
    $('.navbar-brand').attr('style',"color: white; font-family: 'Lobster';");
    $('form').attr('class', '');
    $('.help-block').attr('style',"font-size: 32px;font-family: 'Indie Flower'");
    $('.help-block').eq(0).prepend(
        '<i class="fa fa-money" aria-hidden="true"></i>'
    );
    $('.help-block').eq(1).prepend(
        '<i class="fa fa-home" aria-hidden="true"></i>'
    );
    $('.form-group.shiny-input-container').attr('style',"margin-bottom: 0px;");
    $('h4').attr('style',"margin-top: 5px;margin-bottom: 5px;");

});