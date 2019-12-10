/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */


//this code needs modifications yet its specific.



function validateForm(val) {
  var thruDate = document.forms[val].elements['thruDate'].value;
  var fromDate = document.forms[val].elements['fromDate'].value;

  if(thruDate!="" && fromDate != ""){
    var d= new Date(thruDate);
    var d2= new Date(fromDate)
    if(d2.getTime() >= d.getTime()){
      alert('From Date should be less than Through date');
      return false
    }else{
      return true;
    }
  }else{
    alert ("From Date and Through Date is required");
    return false;
  }

}

function validateForm2() {
  var thruDate1 = document.forms["createCustomTimePeriodForm"]["thruDate"].value;
  var fromDate2 = document.forms["createCustomTimePeriodForm"]["fromDate"].value;

  alert(thruDate1);
  alert(fromDate2);
  if(thruDate1!="" && fromDate2 != ""){

    var parts1= thruDate1.split("/");
    var d4= new Date(parts1[2], parts1[1]-1, parts1[0]);

    var parts= fromDate2.split("/");
    var d5= new Date(parts[2], parts[1]-1, parts[0]);

    alert(d4.getTime()+ " " +  d5.getTime());
    if(d5.getTime() >= d4.getTime()){
      alert('From Date should be less than Through date');
      return false
    }else{
      return true;
    }
  }else{
    alert ("From Date and Through Date is required");
    return false;
  }

}







