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

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

import org.apache.commons.io.FilenameUtils;
import org.apache.ofbiz.base.util.Debug;
import org.apache.ofbiz.base.util.UtilProperties;
import org.apache.ofbiz.base.util.UtilValidate;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericEntityException;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.product.spreadsheetimport.ImportProductHelper;
import org.apache.ofbiz.service.DispatchContext;
import org.apache.ofbiz.service.LocalDispatcher;
import org.apache.ofbiz.service.ServiceUtil;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.*;

public class ImportOhadaPlanServices {

    public static final String module = ImportOhadaPlanServices.class.getName();
    public static final String resource = "ProductUiLabels";

    /**
     * This method is responsible to import spreadsheet data into "Product" and
     * "InventoryItem" entities into database. The method uses the
     * ImportOhadaPlanHelper class to perform its operation. The method uses "Apache
     * POI" api for importing spreadsheet (xls files) data.
     *
     * Note : Create the spreadsheet directory in the ofbiz home folder and keep
     * your xls files in this folder only.
     *
     * @param dctx the dispatch context
     * @param context the context
     * @return the result of the service execution
     * @throws IOException
     */
    public static Map<String, Object> importOhadaPlanFromSpreadsheet(DispatchContext dctx, Map<String, ? extends Object> context) throws IOException {
        Delegator delegator = dctx.getDelegator();
        Locale locale = (Locale) context.get("locale");
        // System.getProperty("user.dir") returns the path upto ofbiz home
        // directory
        String path = System.getProperty("user.dir") + "/spreadsheet";
        List<File> fileItems = new LinkedList<>();

        if (UtilValidate.isNotEmpty(path)) {
            File importDir = new File(path);
            if (importDir.isDirectory() && importDir.canRead()) {
                File[] files = importDir.listFiles();
                // loop for all the containing xls file in the spreadsheet
                // directory
                if (files == null) {
                    return ServiceUtil.returnError(UtilProperties.getMessage(resource, "FileFilesIsNull", locale));
                }
                for (File file : files) {
                    if (file.getName().toUpperCase(Locale.getDefault()).endsWith("XLS")) {
                        fileItems.add(file);
                    }
                }
            } else {
                return ServiceUtil.returnError(UtilProperties.getMessage(resource,
                        "ProductProductImportDirectoryNotFound", locale));
            }
        } else {
            return ServiceUtil.returnError(UtilProperties.getMessage(resource,
                    "ProductProductImportPathNotSpecified", locale));
        }

        if (fileItems.size() < 1) {
            return ServiceUtil.returnError(UtilProperties.getMessage(resource,
                    "ProductProductImportPathNoSpreadsheetExists", locale) + path);
        }

        for (File item: fileItems) {
            if(!importChart(item, delegator, locale,null))
                return ServiceUtil.returnError(UtilProperties.getMessage(resource,
                    "ProductProductImportCannotCreateWorkbookFromFile", locale) + " Or Empty File");

        }
        return ServiceUtil.returnSuccess("Master Template Chart of Account Imported Successfully");
    }


    public static boolean importChart(File item, Delegator delegator, Locale locale, String organizationPartyId) throws IOException{
        // read all xls file and create workbook one by one.
        List<Map<String, Object>> glAccounts = new LinkedList<>();
        List<Map<String, Object>> inventoryItems = new LinkedList<>();

        try{

            glAccounts = getGlAccountsFromFile(item);

        }catch (Exception e){
            e.printStackTrace();
            return false;
        }

        if(glAccounts.isEmpty() || glAccounts == null){
            return  false;
        }
//        Create and Store the GlAccounts in the databases
        for (int j = 0; j < glAccounts.size(); j++) {

            Map<String, Object> glAccount= glAccounts.get(j);

            String originalcode= (String) glAccount.get("accountCode");
//                        Debug.log("\nAccount Code:" + originalcode, module);

            String code="";
            try{
                code= originalcode.trim();
            }catch (Exception e){
                Debug.log("\nCannot not convert code " + originalcode+ " to Integer", module);
                break;
            }

//
//            if( code < 10 ){
//
//                Debug.log("\nAccount Code:" + code, module);
//
//                glAccount.put("glAccountId",""+code);
//                if(!save(glAccount, delegator, locale)){
//
//                    Debug.logError("Cannot store Gl Account", module);
//                    break;
//                }
//            }
//
//            else if(code >=10  &&  code < 100){
//                Debug.log("\nAccount Code:" + code, module);
//
//                String parentCode = "" + originalcode.trim().charAt(0);
//
//                Debug.log("\nParent Code:" + parentCode, module);
//
//                GenericValue parentGV = ImportOhadaPlanHelper.checkGlAccountExists(parentCode, delegator);
//                Debug.log("\nAccount Code:" + code, module);
//
//                if( parentGV!= null){
//                    glAccount.put("parentGlAccountId", parentGV.getString("glAccountId"));
//                }
//                glAccount.put("glAccountId", ""+code);
//
//                if(!save(glAccount, delegator, locale)){
//                    Debug.logError("Cannot store Gl Account", module);
//                    break;
//
//                }
//
//
//            }
//

//            else{


                boolean parentFound= false;
                String divcode= code.trim();
                String searchCode;


                do {
                    //Looking for the parent code

                    if(divcode.length() > 1){
                        divcode = divcode.substring(0, divcode.length()-1);
                    }

                    searchCode = divcode;

                    Debug.log("\nAccount Code:" + divcode, module);
//                                        searchCode is use to complete the 8 character partern for the ohada account


                    if(searchCode.length() > 3) {
                        searchCode= completeToEight(""+ divcode);

                    }

                    if( searchCode.length() == 3) {
                        //There are few accounts with code of 2 digits due to duplicate code on the 8 character pattern
                        searchCode= searchCode.substring(0,2);
                    }

                    Debug.log("\nSearch  Code:" + searchCode, module);


                    //finding code parent
                    GenericValue parentGV = ImportOhadaPlanHelper.checkGlAccountExists(searchCode, delegator);

                    if(searchCode.length() == 2 && parentGV==null){
                        searchCode = completeToEight("" + divcode);
                        parentGV = ImportOhadaPlanHelper.checkGlAccountExists(searchCode, delegator);

                    }

                    if(searchCode.length() < 2 && parentGV==null){

                        glAccount.put("glAccountId",""+code);
                        if (!save(glAccount, delegator, locale)) {
                            Debug.logError("Cannot store Gl Account", module);
                            parentGV = null;
                            break;

                        }
                    }

                    if (parentGV != null) {
                        glAccount.put("parentGlAccountId", parentGV.getString("glAccountId"));
                        parentFound = true;
                        if(code.length() > 2)
                            code =completeToEight(code);
                        glAccount.put("glAccountId",""+ code);
                        if (!save(glAccount, delegator, locale)) {
                            Debug.logError("Cannot store Gl Account", module);
                            parentGV = null;
                            break;

                        }
                        parentGV = null;
                    }



//                                        }

                }while(!parentFound && divcode.length() > 1);

//                                    if(parentFound == false  && divcode <= 0){
//                                        if(save(glAccount, delegator, locale)){
//                                            Debug.logError("Cannot store Gl Account", module);
//                                            break;
//
//                                        }
//                                    }

//            }



//                GenericValue productGV = delegator.makeValue("Product", glAccounts.get(j));
//                GenericValue inventoryItemGV = delegator.makeValue("InventoryItem", inventoryItems.get(j));
//                if (!ImportProductHelper.checkProductExists(productGV.getString("productId"), delegator)) {
//                    try {
//                        delegator.create(productGV);
//                        delegator.create(inventoryItemGV);
//                    } catch (GenericEntityException e) {
//                        Debug.logError("Cannot store product", module);
//                        return ServiceUtil.returnError(UtilProperties.getMessage(resource,
//                                "ProductProductImportCannotStoreProduct", locale));
//                    }
//                }

                glAccounts.get(j).put("glAccountId", code);
        }


        /*If the chart of account is for a specific organization */
        if(organizationPartyId!=null){

            for( Map<String, Object> glAccount : glAccounts){
                Map<String, Object> glAccountOrganization = ImportOhadaPlanHelper.prepareOrganizationGlAccount((String) glAccount.get("glAccountId"), organizationPartyId);
                saveOrganizationGlAccount(glAccountOrganization,delegator,locale);
            }
        }


        int uploadedGlAccounts = glAccounts.size() + 1;
        if (glAccounts.size() > 0) {
            Debug.logInfo("Uploaded " + uploadedGlAccounts + " glAccounts from file " + item.getName(), module);
        }
        return true;
    }



    public static  List<Map<String, Object>>  getGlAccountsFromFile(File item) throws  IOException{
        List<Map<String, Object>> glAccounts = new LinkedList<>();
        POIFSFileSystem fs = null;
      Workbook  wb = null;
                String extension = FilenameUtils.getExtension(item.getName());
                Debug.log("Extension  of the file is : "+ extension);
        try {
//            fs = new POIFSFileSystem(new FileInputStream(item));
            wb = WorkbookFactory.create(item);
        } catch (IOException e) {
            Debug.logError("Unable to read or create workbook from file", module);
            e.printStackTrace();
            throw e;
//            return ServiceUtil.returnError(UtilProperties.getMessage(resource,
//                    "ProductProductImportCannotCreateWorkbookFromFile", locale));
//            return false;
        }

        String glAccountName;
        String glAccountTypeId;
        String glAccountClassId;
        String glAccountCode;
        // get first sheet
        Sheet sheet = wb.getSheetAt(0);
        wb.close();
        int sheetLastRowNumber = sheet.getLastRowNum();
        for (int j = 1; j <= sheetLastRowNumber; j++) {
            Row row = sheet.getRow(j);
            if (row != null) {

                // read productId from first column "sheet column index
                // starts from 0"
                //Getting the code column
                Cell cell0 = row.getCell(0);

                if(cell0 ==null){
                    glAccountCode= "_NA_";
                }else {
                    cell0.setCellType(CellType.STRING);
                    glAccountCode = cell0.getRichStringCellValue().toString();
                    if(glAccountCode==null || glAccountCode.isEmpty()){
                        glAccountCode ="_NA_";
                    }
                }

                //Getting the name column
                Cell cell1 = row.getCell(1);

                    if(cell1==null){
                        glAccountName="_NA_";

                    }else {
                        cell1.setCellType(CellType.STRING);
                        glAccountName = cell1.getRichStringCellValue().toString();
                        if(glAccountName==null || glAccountName.isEmpty()){
                            glAccountName="_NA_";
                        }
                    }



                //Getting the type column

                Cell cell4 = row.getCell(4);
                if(cell4 == null){
                    glAccountTypeId ="_NA_";

                }else{
                    cell4.setCellType(CellType.STRING);
                    glAccountTypeId = cell4.getRichStringCellValue().toString();

                    if(glAccountTypeId==null || glAccountTypeId.isEmpty()){
                        glAccountTypeId ="_NA_";
                    }
                }


                //Getting the class column
                Cell cell5 = row.getCell(5);

                if(cell5==null){

                    glAccountClassId= "_NA_";

                }else {
                    cell5.setCellType(CellType.STRING);
                    glAccountClassId = cell5.getRichStringCellValue().toString();

                    if(glAccountClassId==null || glAccountClassId.trim().isEmpty()){
                        glAccountClassId= "_NA_";
                    }
                }


                // read QOH from ninth column
//                    HSSFCell cell5 = row.getCell(5);
//                    BigDecimal quantityOnHand = BigDecimal.ZERO;
//                    if (cell5 != null && cell5.getCellType() == CellType.NUMERIC) {
//                        quantityOnHand = new BigDecimal(cell5.getNumericCellValue());
//                    }

                //starting the save

                // check productId if null then skip creating inventory item
                // too.
                Debug.log("Account Code: "+ glAccountCode, module);
                glAccounts.add(org.apache.ofbiz.accounting.ohada.ImportOhadaPlanHelper.prepareGlAccount(null,null,glAccountCode,glAccountName ,glAccountTypeId,glAccountClassId));

            }

//                    int rowNum = row.getRowNum() + 1;
//                    if (!row.toString().trim().equalsIgnoreCase("")) {
//                        Debug.logWarning("Row number " + rowNum + " not imported from " + item.getName(), module);
//                    }
        }

        glAccounts.sort(Comparator.comparing(m->((String)m.get("accountCode")).trim(), Comparator.nullsLast(Comparator.naturalOrder())));

        return  glAccounts;
    }


    public static  boolean saveOrganizationGlAccount(Map<String, Object> glAccountOrganization, Delegator delegator, Locale locale){

        if(ImportOhadaPlanHelper.checkOrganizationGlAccountExists((String) glAccountOrganization.get("glAccountId"),(String) glAccountOrganization.get("organizationPartyId"),delegator) == null) {

            GenericValue glAccountOrganizationGV = delegator.makeValue("GlAccountOrganization", glAccountOrganization);

            try {

                delegator.createOrStore(glAccountOrganizationGV);
            } catch (Exception e) {
                Debug.logError("Cannot store Gl Account "+(String) glAccountOrganization.get("glAccountId") + " For organization "+ (String) glAccountOrganization.get("organizationPartyId"), module);
                e.printStackTrace();
                return false;
            }
        }
        return  true;
    }

    public static  boolean save(Map<String, Object> glAccount, Delegator delegator, Locale locale){

        if(!ImportOhadaPlanHelper.checkGlAccountClassExists((String) glAccount.get("glAccountClassId"), delegator)){
                GenericValue glAccountClassGV= delegator.makeValue("GlAccountClass", ImportOhadaPlanHelper.prepareGlAccountClass( (String) glAccount.get("glAccountClassId") ));

                try {
                    delegator.createOrStore(glAccountClassGV);
                }catch(Exception e){
                    Debug.logError("Cannot store Gl Account class", module);
                    e.printStackTrace();
                    return false;
                }

        }

        if(!ImportOhadaPlanHelper.checkGlAccountTypeExists((String) glAccount.get("glAccountTypeId"), delegator)){
            GenericValue glAccountTypeGV= delegator.makeValue("GlAccountType", ImportOhadaPlanHelper.prepareGlAccountType ((String) glAccount.get("glAccountTypeId") ));

            try {
                delegator.createOrStore(glAccountTypeGV);
            }catch(Exception e){
                Debug.logError("Cannot store Gl Account Type", module);
                e.printStackTrace();
                return  false;
            }

        }
        String s_code= (String) glAccount.get("accountCode");
            s_code = completeToEight(s_code);
        if(ImportOhadaPlanHelper.checkGlAccountExists((String) glAccount.get("accountCode"),delegator) == null || ImportOhadaPlanHelper.checkGlAccountExists(s_code,delegator) == null) {

            GenericValue glAccountGV = delegator.makeValue("GlAccount", glAccount);

            try {

                delegator.createOrStore(glAccountGV);
            } catch (Exception e) {
                Debug.logError("Cannot store Gl Account " + glAccount.get("glAccountClassId"), module);
                e.printStackTrace();
                throw  new RuntimeException("Error");
//                return false;
            }
        }
        return  true;
    }


    public static String completeToEight(String code){
                if(code.length()==8)
                    return  code;
                if(code.length() < 8){
                        do{
                            code+="0";

                        }while(code.length() < 8);

                }
        return code;
    }
}
