$(document).ready(function(){

  $("#backup_task_protocol").change(function () {
    if (this.options[this.selectedIndex].value == "local") {
      $("#backup-task-external-destination-details").hide()
    } else {
      $("#backup-task-external-destination-details").show()
    }
  })


})


