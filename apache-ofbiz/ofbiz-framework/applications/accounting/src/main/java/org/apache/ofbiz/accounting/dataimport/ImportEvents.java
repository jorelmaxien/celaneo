package org.apache.ofbiz.accounting.dataimport;

import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.io.FileOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.ofbiz.accounting.ohada.ImportOhadaPlanServices;
import org.apache.ofbiz.base.util.Debug;
import org.apache.ofbiz.base.util.UtilHttp;
import org.apache.ofbiz.base.util.UtilMisc;
import org.apache.ofbiz.base.util.UtilProperties;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.minilang.SimpleMethod;
import org.apache.ofbiz.service.LocalDispatcher;

import java.util.List;
import java.util.Locale;

public class ImportEvents {
    public static String module= ImportEvents.class.getName();
    public static String organizationPartyId=null;
    public static String uploadedFileName;
    public static File uploadDir;


    public static String uploadOrganizationChartOfAccount(HttpServletRequest request, HttpServletResponse response){
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");
        Locale locale = UtilHttp.getLocale(request);
        String result = uploadFile(request,response);
        uploadDir = new File (System.getProperty("user.dir") +File.separator+ uploadDir);
        if(result.equals("success")){

            try {

                File uploadedFile = new File(uploadDir+File.separator+uploadedFileName);
                Debug.log(uploadDir+File.separator+uploadedFileName);

                if(ImportOhadaPlanServices.importChart(uploadedFile,delegator,locale,organizationPartyId)) {
                    request.setAttribute("_EVENT_MESSAGE_LIST", UtilMisc.toList(result, "Chart import Successful"));

                }else {
                    request.setAttribute("_ERROR_MESSAGE_",  "Error  while importing Data");

                }

            }catch (Exception e){
                e.printStackTrace();
                request.setAttribute("_ERROR_MESSAGE_",  "Error  while importing");

            }

            request.setAttribute("_EVENT_MESSAGE_","Organization Account Chart import Successful");

        }else {
            request.setAttribute("_ERROR_MESSAGE_",  "Error  while uploading File");

        }

        return  ("success");

    }


    public static String uploadFile(HttpServletRequest request, HttpServletResponse response)
    {
        String uploadFilePath = UtilProperties.getPropertyValue("general", "http.upload.tmprepository", "runtime/tmp");
        //ServletFileUpload fu = new ServletFileUpload(new DiskFileItemFactory(10240, new File(new File("runtime"), "tmp")));           //Creation of servletfileupload
        System.out.println("\n\n\t****************************************\n\tuploadFile(HttpServletRequest request,HttpServletResponse response) - start\n\t");
        ServletFileUpload fu = new ServletFileUpload(new DiskFileItemFactory());           //Creation of servletfileupload
        List lst = null;
        String result="exception";
        String file_name="";

        uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            System.out.print("No Folder");
            uploadDir.mkdir();
            System.out.print("Folder created");
        }
        try
        {
            lst = fu.parseRequest(request);
        }
        catch (FileUploadException fup_ex)
        {
            System.out.println("\n\n\t****************************************\n\tException of FileUploadException \n\t");
            fup_ex.printStackTrace();
            result="exception";
            return(result);
        }

        if(lst.size()==0)        //There is no item in lst
        {
            System.out.println("\n\n\t****************************************\n\tLst count is 0 \n\t");
            result="exception";
            return(result);
        }


        FileItem file_item = null;
        FileItem selected_file_item=null;

        //Checking for form fields - Start
        for (int i=0; i < lst.size(); i++)
        {
            file_item=(FileItem)lst.get(i);
            String fieldName = file_item.getFieldName();

            if(fieldName.equals("organizationPartyId"))
            {
                organizationPartyId =file_item.getString();

                //String file_name=file_item.getString();
                //file_name=request.getParameter("filename");
                //Getting the file name
                System.out.println("\n\n\t****************************************\n\tThe organization id is : "+organizationPartyId+"\n\t");
                break;
            }
            //Check for the attributes for user selected file - End
        }
        //Checking for form fields - Start
        for (int i=0; i < lst.size(); i++)
        {
            file_item=(FileItem)lst.get(i);
            String fieldName = file_item.getFieldName();

            if(fieldName.equals("filename"))
            {
                selected_file_item=file_item;
                //String file_name=file_item.getString();
                //file_name=request.getParameter("filename");
                file_name=file_item.getName();             //Getting the file name
                System.out.println("\n\n\t****************************************\n\tThe selected file item's file name is : "+file_name+"\n\t");
                break;
            }
            //Check for the attributes for user selected file - End
        }
        //Checking for form fields - End

        //Uploading the file content - Start
        if(selected_file_item==null)                    //If selected file item is null
        {
            System.out.println("\n\n\t****************************************\n\tThe selected file item is null\n\t");
            result="exception";
            return(result);
        }

        byte[] file_bytes=selected_file_item.get();
        byte[] extract_bytes=new byte[file_bytes.length];

        for(int l=0;l<file_bytes.length;l++)
            extract_bytes[l]=file_bytes[l];
        //ByteBuffer byteWrap=ByteBuffer.wrap(file_bytes);
        //byte[] extract_bytes;
        //byteWrap.get(extract_bytes);


        //System.out.println("\n\n\t****************************************\n\tExtract succeeded :content are : \n\t");


        if(extract_bytes==null)
        {
            System.out.println("\n\n\t****************************************\n\tExtract bytes is null\n\t");
            result="exception";
            return(result);
        }

            /*
            for(int k=0;k<extract_bytes.length;k++)
                System.out.print((char)extract_bytes[k]);
            */

        //String target_file_name="/hot-deploy/productionmgntSystem"
        //Creation & writing to the file in server - Start
        try
        {
            //Testing if file of same name  exist and delete previous.
            File fileToUpload= new File(uploadDir +"/"+ file_name);
            if (fileToUpload.exists()) {
                System.out.print("Previous Version of file Exist");
                fileToUpload.delete();
                System.out.println(" Parameter of the organization: "+ request.getParameter("organizationPartyId"));
                System.out.print("Previous version deleted....");
            }

            FileOutputStream fout=new FileOutputStream(uploadDir +"/"+ file_name);
            System.out.println("\n\n\t****************************************\n\tAfter creating outputstream");
            fout.flush();
            fout.write(extract_bytes);
            fout.flush();
            fout.close();
            uploadedFileName =file_name;

        }
        catch(IOException ioe_ex)
        {
            System.out.println("\n\n\t****************************************\n\tIOException occured on file writing");
            ioe_ex.printStackTrace();
            result="exception";
            return(result);
        }
        //Creation & writing to the file in server - End
//    request.setAttribute("_EVENT_MESSAGE_","File Upload Successfull");
        System.out.println("\n\n\t****************************************\n\tuploadFile(HttpServletRequest request,HttpServletResponse response) - end\n\t");
        return("success");
        //Uploading the file content - End
    }




}
