$(document).ready(function(){

  $("#backup_task_protocol_ftp").change(function () {
    set_external_destination_details(this);
  });

  $("#backup_task_protocol_s3").change(function () {
    set_external_destination_details(this);
  });

  $("#backup_task_protocol_smbfs").change(function () {
    set_external_destination_details(this);
  });

  $("#backup_task_protocol_nfs").change(function () {
    set_external_destination_details(this);
  });

  $("#backup_task_protocol_local").change(function () {
    set_external_destination_details(this);
  });

  function set_external_destination_details(radio_button) {
    if ((radio_button.checked == true) && (radio_button.id != 'backup_task_protocol_local')) {
      $("#backup-task-external-destination-details").show()
    } else {
      $("#backup-task-external-destination-details").hide()
    };
  };

})


