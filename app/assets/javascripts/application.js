// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require jquery3
//= require popper
//= require bootstrap-sprockets

function copyToClipboard(){
    let id = document.getElementById('id')
    let temp = $("<input>")
    $('body').append(temp)
    temp.val($(id).text()).select()
    document.execCommand('copy')
    temp.remove()
}

function checkNewEvent(element){
    if(element.value === "") {
        document.getElementById('submit').disabled = true
    }
    else {
        document.getElementById('submit').disabled = false
    }
}

function getMedications(studentId){
    $.ajax({
        type: 'GET',
        url: '/events/new',
        data: {
            student_id: studentId
        },
        success: function (data) {
            $('#event_med_id').replaceWith(data)
        }
    })
}