$(document).ready(function() {
    $('#list').click(function(event){event.preventDefault();$('#categories-list .item').addClass('list-group-item');});
    $('#grid').click(function(event){event.preventDefault();$('#categories-list .item').removeClass('list-group-item');$('#categories-list .item').addClass('grid-group-item');});
});
