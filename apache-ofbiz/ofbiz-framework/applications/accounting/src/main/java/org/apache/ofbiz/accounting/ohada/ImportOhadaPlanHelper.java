
/*******************************************************************************
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
 *******************************************************************************/

package org.apache.ofbiz.accounting.ohada;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.github.sisyphsu.dateparser.DateParser;
import org.apache.ofbiz.base.util.Debug;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericEntityException;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.entity.util.EntityQuery;

public final class ImportOhadaPlanHelper {

    public static final String module = ImportOhadaPlanHelper.class.getName();

    private ImportOhadaPlanHelper() {}

    // prepare the GlAccount map
    public static Map<String, Object> prepareGlAccount(String glAccountId, String parentGlAccountId, String glAccountCode,  String glAccountName, String glAccountTypeId, String glAccountClassId) {
        Map<String, Object> fields = new HashMap<>();
        String accountClassId=  glAccountClassId.toUpperCase().replaceAll(" ", "_");
        if(accountClassId.length() > 20){
            accountClassId= accountClassId.substring(0,19);
        }
        String accountTypeId=  glAccountTypeId.toUpperCase().replaceAll(" ", "_");
        if(accountTypeId.length() > 20){
            accountTypeId= accountTypeId.substring(0,19);
        }
        fields.put("glAccountId", glAccountId);
        if(parentGlAccountId!=null && !parentGlAccountId.isEmpty()){
            fields.put("parentGlAccountId", parentGlAccountId);
        }

        if(accountClassId.trim().isEmpty()){
            glAccountClassId="_NA_";
        }

        if(accountTypeId.trim().isEmpty()){
            glAccountTypeId ="_NA_";
        }
        fields.put("accountName", glAccountName);
        fields.put("accountCode", glAccountCode.trim());
        fields.put("glAccountTypeId", accountTypeId);
        fields.put("glAccountClassId", accountClassId);
        fields.put("glResourceTypeId", "_NA_");
        fields.put("description", glAccountCode+ " " + glAccountName);
        return fields;
    }

    public static Map<String, Object> prepareOrganizationGlAccount(String glAccountId, String organizationPartId) {
        Map<String, Object> fields = new HashMap<>();

        String accountId=  glAccountId == null ? "_NA_" : glAccountId;
        String organizationId=  organizationPartId == null ? "_NA_" : organizationPartId;

        fields.put("glAccountId", accountId);
        fields.put("organizationPartyId", organizationId);
        fields.put("fromDate",  new java.sql.Timestamp(new Date().getTime()));
        return fields;
    }



    public static Map<String, Object> prepareGlAccountClass(String glAccountClassId) {
        Map<String, Object> fields = new HashMap<>();
        String accountClassId=  glAccountClassId.toUpperCase().replaceAll(" ", "_");
        if(accountClassId==null || accountClassId.isEmpty()){
            accountClassId="_NA_";
        }
        if(accountClassId.length() > 20){
            accountClassId= accountClassId.substring(0,19);
        }
        fields.put("glAccountClassId", accountClassId);
        fields.put("description", glAccountClassId);
        return fields;
    }



    public static Map<String, Object> prepareGlAccountType(String glAccountTypeId) {
        Map<String, Object> fields = new HashMap<>();
        String accountTypeId=  glAccountTypeId.toUpperCase().replaceAll(" ", "_");
      if(accountTypeId==null || accountTypeId.isEmpty() ){
          accountTypeId="_NA_";
      }

        if(accountTypeId.length() > 20){
            accountTypeId= accountTypeId.substring(0,19);
        }
        fields.put("glAccountTypeId", accountTypeId);
        fields.put("description", glAccountTypeId);
        fields.put("hasTable", "N");
        return fields;
    }

//    // prepare the inventoryItem map
//    public static Map<String, Object> prepareInventoryItem(String productId,
//            BigDecimal quantityOnHand, String inventoryItemId) {
//        Map<String, Object> fields = new HashMap<>();
//        fields.put("inventoryItemId", inventoryItemId);
//        fields.put("inventoryItemTypeId", "NON_SERIAL_INV_ITEM");
//        fields.put("productId", productId);
//        fields.put("ownerPartyId", "Company");
//        fields.put("facilityId", "WebStoreWarehouse");
//        fields.put("quantityOnHandTotal", quantityOnHand);
//        fields.put("availableToPromiseTotal", quantityOnHand);
//        return fields;
//    }

    // check if GlAccount Exist already exists in database
    public static GenericValue checkGlAccountExists(String glAccountCode,
            Delegator delegator) {
        GenericValue tmpGlAccountGV;
        GenericValue glAccountExists=null;
        try {
            tmpGlAccountGV = EntityQuery.use(delegator).from("GlAccount").where("accountCode", glAccountCode.trim()).queryOne();
            if (tmpGlAccountGV != null
                    && glAccountCode.trim().equals(tmpGlAccountGV.getString("accountCode"))) {
                glAccountExists = tmpGlAccountGV;
            }
        } catch (GenericEntityException e) {
            Debug.logError("Problem in reading data of General Ledger Account", module);
        }
        return glAccountExists;
    }

    // check if GlAccount Exist already exists in database
    public static GenericValue checkOrganizationGlAccountExists(String glAccountId,String organizationPartyId,
                                                    Delegator delegator) {
        GenericValue tmpGlAccountGV;
        GenericValue glAccountExists=null;
        try {
            tmpGlAccountGV = EntityQuery.use(delegator).from("GlAccountOrganization").where("glAccountId", glAccountId.trim(), "organizationPartyId", organizationPartyId.trim()).queryOne();
            if (tmpGlAccountGV != null
                    && glAccountId.trim().equals(tmpGlAccountGV.getString("glAccountId"))  && organizationPartyId.trim().equals(tmpGlAccountGV.getString("organizationPartyId"))) {
                glAccountExists = tmpGlAccountGV;
            }
        } catch (GenericEntityException e) {
            Debug.logError("Problem in reading data of General Ledger Account", module);
        }
        return glAccountExists;
    }




    public static boolean checkGlAccountClassExists(String glAccountClassId,
                                               Delegator delegator) {
        GenericValue tmpGlAccountClassGV;
        boolean glAccountClassExists = false;
        try {
            tmpGlAccountClassGV = EntityQuery.use(delegator).from("GlAccountClass").where("glAccountClassId", glAccountClassId.toUpperCase().replaceAll(" ", "_")).queryOne();
            if (tmpGlAccountClassGV != null
                    && glAccountClassId.toUpperCase().replaceAll(" ","_").equals(tmpGlAccountClassGV.getString("glAccountClassId"))) {
                glAccountClassExists = true;
            }
        } catch (GenericEntityException e) {
            Debug.logError("Problem in reading data of General Ledger Account Class", module);
        }
        return glAccountClassExists;
    }


    public static boolean checkGlAccountTypeExists(String glAccountTypeId,
                                                    Delegator delegator) {
        GenericValue tmpGlAccountTypeGV;
        boolean glAccountTypeExists = false;
        try {
            tmpGlAccountTypeGV = EntityQuery.use(delegator).from("GlAccountType").where("glAccountTypeId", glAccountTypeId.toUpperCase().replaceAll(" ", "_")).queryOne();
            if (tmpGlAccountTypeGV != null
                    && glAccountTypeId.toUpperCase().replaceAll(" ", "_").equals(tmpGlAccountTypeGV.getString("glAccountTypeId"))) {
                glAccountTypeExists = true;
            }
        } catch (GenericEntityException e) {
            Debug.logError("Problem in reading data of General Ledger Account Type", module);
        }
        return glAccountTypeExists;
    }




}
