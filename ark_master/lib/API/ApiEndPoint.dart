class ApiEndPoint
  {
  // ApiEndPoint
    static const String BASE_URL_CLIENTS = "http://arkledger.techregnum.com/api/";
    static const String BASE_URL_UPLOAD_IMAGE = "http://arkledger.techregnum.com/api/";
    static const String UPLOAD_IMAGE_FOR_INVOICE_FORMAT = "FileUpload/uploadClientCompaniesLogo";
    static const String UPLOAD_CLIENT_COMPANY_LOGO = "FileUpload/uploadClientCompaniesLogo";
    static const String UPLOAD_PROFILE_IMAGE="FileUpload/uploadAppClientUsersProfilePicImages";
    static const String UPLOAD_PRODUCT_IMAGE="FileUpload/uploadProductImages";
    static const String UPLOAD_OFFER_IMAGE="FileUpload/uploadOfferImages";
    static const String UPLOAD_EMPLOYEE_PROFILE_PIC_IMAGE="FileUpload/uploadEmployeeProfilePicImages";

  //Menu Mapping
     static const String GET_HIERARCHY_MENU_LIST = "menu/getHierarchyMenuList";

  //Login
   static const String LOGIN_VERIFICATION = "AppClientUsers/login";
   static const String FORGOT_PASSWORD = "AppClientUsers/forgetPassword";
   static const String GENERATE_OTP = "AppClientUsers/generateOTP";
   static const String GET_PROFILE="AppClientUsers/getProfile";
   static const String UPDATE_PROFILE="AppClientUsers/updateProfile";
   static const String CHANGE_PASSWORD="AppClientUsers/changePassword";

  //CUSTOMER
   static const String GET_CUSTOMER_CLIENT_MAPPING_LIST_FOR_SEARCH = "CustomerClientMapping/getCustomerClientMappingListForSearch";
   static const String SAVE_CUSTOMER_CLIENT_MAPPING = "CustomerClientMapping/saveCustomerClientMapping";
   static const String UPDATE_CUSTOMER_CLIENT_MAPPING = "CustomerClientMapping/editCustomerClientMapping";
   static const String GET_CUSTOMER_CLIENT_MAPPING_LIST = "CustomerClientMapping/getCustomerClientMappingList";
   static const String ENABLE_CUSTOMER_CLIENT_MAPPING = "CustomerClientMapping/enableCustomerClientMapping";
   static const String DISABLE_CUSTOMER_CLIENT_MAPPING = "CustomerClientMapping/disableCustomerClientMapping";
   static const String GET_CUSTOMERS_DETAILS = "customers/getCustomersDetails";

  //AppClientUsers
   static const String GET_APP_CLIENT_USER_LIST = "AppClientUsers/getAppClientUsersList";
   static const String ENABLE_CLIENT_USERS="AppClientUsers/enableAppClientUsers";
   static const String DISABLE_CLIENT_USERS="AppClientUsers/disableAppClientUsers";
   static const String DELETE_CLIENT_USERS="AppClientUsers/deleteAppClientUsers";
   static const String SAVE_APP_CLIENT_USERS="AppClientUsers/saveAppClientUsers";

  //ClientCompanies
   static const String GET_CLIENT_COMPANIES_LIST = "ClientCompanies/getClientCompaniesList";
   static const String SAVECLIENTCOMPANIES="clientCompanies/saveClientCompanies";
   static const String ENABLE_CLIENT_COMPANIES = "ClientCompanies/enableClientCompanies";
   static const String DISABLE_CLIENT_COMPANIES = "ClientCompanies/disableClientCompanies";
   static const String DELETE_CLIENT_COMPANIES = "ClientCompanies/deleteClientCompanies";

  //Invoice
   static const String SAVEINVOICES="Invoices/saveInvoices";
   static const String GET_INVOICES_LIST="Invoices/getInvoicesList";
   static const String GET_INVOICE_DETAIL = "Invoices/getInvoicesDetail";
   static const String UPDATE_PAYMENT_STATUS = "Invoices/updatePaymentStatus";

  //Credit Ledger
   static const String SAVE_CREDIT_LEDGER = "CreditLedger/saveCreditLedger";
   static const String GET_CREDIT_LEDGRE_FOR_CLIENT = "CreditLedger/getPendingLedgerForClient";
   static const String GET_PENDING_CREDIT_LEDGRE_FOR_CLIENT_COMPANIES = "CreditLedger/getPendingLedgerForCompanies";
   static const String CREATE_INVOICE_FOR_CREDIT_LEDGER = "CreditLedger/createInvoiceForCreditLedger";
   static const String GET_CREDIT_LEDGRE_DETAILS = "CreditLedger/getCustomerCreditLedger";
   static const String SEND_PAYMENT_REMINDER = "Invoices/sendPaymentReminder";

  //InvoiceFormats
   static const String GET_INVOICE_FORMATS_APP_COMPANY_MAPPING_LIST ="InvoiceFormatAppCompanyMapping/getInvoiceFormatsAppCompanyMappingList";
   static const String SAVEINVOICEFORMAT="InvoiceFormatAppCompanyMapping/saveInvoiceFormatsAppCompanyMapping";
   static const String GETINVOICEFORMATLIST="InvoiceFormats/getInvoiceFormatsList";
   static const String GET_FORMAT_DETAILS="InvoiceFormats/getInvoiceFormatsDetails";

  //EXPENSES
   static const String GET_EXPENSES_LIST ="expenses/getExpensesList";
   static const String SAVE_EXPENSES="expenses/saveExpenses";
   static const String GET_EXPENSES_TYPE_LIST ="expenseType/getExpenseTypeList";
   static const String DELETE_EXPENSES ="expenses/deleteExpenses";
   static const String ENABLE_EXPENSES ="expenses/enableExpenses";
   static const String DISABLE_EXPENSES ="expenses/disableExpenses";

  //HSNSACCODELIST
   static const String GET_HSNSACCODELIST="HsnSacCode/getPendingHsnSacCodeList";
   static const String SAVE_APPCLIENT_HSNSACCODE="appClientHsnSacCode/saveAppClienthsnsac";
   static const String GET_APP_CLIENT_HSN_SAC_LIST="appClientHsnSacCode/getAppClienthsnsacList";
   static const String ENABLE_APP_CLIENT_HSN_SAC="appClientHsnSacCode/enableAppClientHsnSac";
   static const String DISABLE_APP_CLIENT_HSN_SAC="appClientHsnSacCode/disableAppClientHsnSac";
   static const String DELETE_APPCLIENT_HSNSACCODE="appClientHsnSacCode/deleteAppClientHsnSac";

  //Business Details
   static const String GET_APP_CLIENTS_DETAILS="AppClients/getAppClientsDetails";

  //ProductCategory
   static const String GET_PRODUCT_CATEGORY_LIST = "ProductCategories/getProductCategoriesList";
   static const String GET_PRODUCT_SUB_CATEGORY_LIST = "ProductSubcategories/getProductSubCategoriesList";

  //ForDropdown
   static const String GET_PENDING_PRODUCT_CATEGORY_LIST = "ProductCategories/getPendingProductCategoryList";
   static const String GET_PENDING_PRODUCT_SUBCATEGORY_LIST = "ProductSubcategories/getPendingProductSubCategoriesList";

  //Forlist
   static const String GET_MAP_PRODUCT_CATEGORY_LIST = "productCategorySubcategoryClientMapping/getMapProductCategoryList";
   static const String GET_MAP_PRODUCT_SUB_CATEGORY_LIST = "productCategorySubcategoryClientMapping/getMapProductSubcategoryList";

   static const String SAVE_PRODUCT_SUBCATEGORY_CLIENT_MAPPING_LIST = "productCategorySubcategoryClientMapping/saveProductCategorySubcategoryClientMapping";
   static const String ENABLE_PRODUCT_SUBCATEGORY_CLIENT_MAPPING_LIST = "productCategorySubcategoryClientMapping/enableProductCategorySubcategoryClientMapping";
   static const String DISABLE_PRODUCT_SUBCATEGORY_CLIENT_MAPPING_LIST = "productCategorySubcategoryClientMapping/disableProductCategorySubcategoryClientMapping";
   static const String DELETE_PRODUCT_SUBCATEGORY_CLIENT_MAPPING_LIST = "productCategorySubcategoryClientMapping/deleteProductCategorySubcategoryClientMapping";

  //BUSINESS_CATEGORY_LIST
   static const String GET_BUSINESS_CATEGORY_LIST = "businessCategory/getBusinessCategoryList";
   static const String GET_BUSINESS_SUBCATEGORY_LIST = "businessSubcategory/getBusinessSubcategoryList";

   static const String GET_PENDING_BUSINESS_CATEGORY_LIST = "businessCategory/getPendingBusinessCategoryList";
   static const String GET_PENDING_BUSINESS_SUBCATEGORY_LIST = "businessSubcategory/getPendingBusinessSubcategoryList";

   static const String GET_MAP_BUSINESS_CATEGORY_LIST = "BusinessCategorySubcategoryClientMapping/getMapBusinessCategoryList";
   static const String GET_MAP_BUSINESS_SUBCATEGORY_LIST = "BusinessCategorySubcategoryClientMapping/getMapBusinessSubcategoryList";

   static const String ENABLE_BUSINESS_CATEGORY_SUBCATEGORY_CLIENT_MAPPING_LIST = "BusinessCategorySubcategoryClientMapping/enableBusinessCategorySubcategoryClientMapping";
   static const String DISABLE_BUSINESS_CATEGORY_SUBCATEGORY_CLIENT_MAPPING_LIST = "BusinessCategorySubcategoryClientMapping/disableBusinessCategorySubcategoryClientMapping";
    static const String DELETE_BUSINESS_CATEGORY_CLIENT_MAPPING_LIST = "BusinessCategorySubcategoryClientMapping/deleteBusinessCategorySubcategoryClientMapping";
   static const String SAVE_BUSINESS_CATEGORY_CLIENT_MAPPING_LIST = "BusinessCategorySubcategoryClientMapping/saveBusinessCategorySubcategoryClientMapping";

  //Products //ClientItems
   static const String GET_PRODUCT_LIST = "ClientItems/getClientItemsList";
   static const String SAVE_PRODUCTS = "ClientItems/saveClientItems";
   static const String DELETE_CLIENT_ITEMS = "ClientItems/deleteClientItems";
   static const String ENABLE_CLIENT_ITEMS = "ClientItems/enableClientItems";
   static const String DISABLE_CLIENT_ITEMS = "ClientItems/disableClientItems";

  //OFFERs
   static const String GET_OFFERS_LIST = "offers/getOffersList";
   static const String SAVE_OFFERS = "offers/saveOffers";
   static const String GET_OFFERS_DETAILS = "offers/getOffersDetails";
   static const String DELETE_OFFERS = "offers/deleteOffers";
   static const String ENABLE_OFFERS = "offers/enableOffers";
   static const String DISABLE_OFFERS = "offers/disableOffers";

  //Employee
   static const String GET_EMPLOYEE_LIST = "employee/getEmployeeList";
   static const String SAVE_EMPLOYEE = "employee/saveEmployee";
   static const String GET_DESIGNATION_LIST = "Designation/getDesignationList";
   static const String DELETE_EMPLOYEE = "employee/deleteEmployee";
   static const String ENABLE_EMPLOYEE = "employee/enableEmployee";
   static const String DISABLE_EMPLOYEE = "employee/disableEmployee";

  //employeeSalary
   static const String GET_EMPLOYEE_SALARY_LIST = "employeeSalary/getEmployeeSalaryList";
   static const String SAVE_EMPLOYEE_SALARY = "employeeSalary/saveEmployeeSalary";
   static const String CALCULATE_EMPLOYEE_SALARY = "employeeSalary/calculateEmployeeSalary";

  //EmployeeLeaves
   static const String GET_EMPLOYEE_LEAVE_LIST = "EmployeeLeaves/getEmployeeLeavesList";
   static const String SAVE_EMPLOYEE_LEAVE= "EmployeeLeaves/saveEmployeeLeaves";
   static const String DELETE_EMPLOYEE_LEAVE= "EmployeeLeaves/deleteEmployeeLeaves";
   static const String ENABLE_EMPLOYEE_LEAVE= "EmployeeLeaves/enableEmployeeLeaves";
   static const String DISABLE_EMPLOYEE_LEAVE= "EmployeeLeaves/disableEmployeeLeaves";

  //EmployeeLeavesRequest
   static const String GET_EMPLOYEE_LEAVE_REQUEST = "EmployeeLeavesRequest/getEmployeeLeavesRequestList";
   static const String APPROVE_EMPLOYEE_LEAVES_REQUEST = "EmployeeLeavesRequest/approveEmployeeLeavesRequest";
   static const String REJECT_EMPLOYEE_LEAVES_REQUEST = "EmployeeLeavesRequest/rejectEmployeeLeavesRequest";

  //getEmployeeCompanyLinkingList
   static const String GET_EMPLOYEE_COMPANY_LINKING_LIST= "employeeCompanyLinking/getEmployeeCompanyLinkingList";
   static const String SAVE_EMPLOYEE_COMPANY_LINKING_LIST= "employeeCompanyLinking/saveEmployeeCompanyLinking";

  //getEmployeeCompanyLinkingList
   static const String GET_APP_CLIENT_OFFICE_LIST= "appClientOffice/getAppClientOfficeList";

  //getEmployeeCompanyLinkingList
    static const String GET_EMPLOYEE_EMERGENCY_DETAILS_LIST= "employeeEmergencyDetails/getEmployeeEmergencyDetailsList";
   static const String SAVE_EMPLOYEE_EMERGENCY_DETAILS= "employeeEmergencyDetails/saveEmployeeEmergencyDetails";
   static const String ENABLE_EMPLOYEE_EMERGENCY_DETAILS= "employeeEmergencyDetails/enableEmployeeEmergencyDetails";
   static const String DISABLE_EMPLOYEE_EMERGENCY_DETAILS= "employeeEmergencyDetails/disableEmployeeEmergencyDetails";
   static const String DELETE_EMPLOYEE_EMERGENCY_DETAILS= "employeeEmergencyDetails/deleteEmployeeEmergencyDetails";

  //Relation
   static const String GET_RELATION_LIST= "relation/getRelationList";

  //Project
   static const String GET_PROJECT_LIST= "Projects/getProjectsList";
   static const String SAVE_PROJECT= "Projects/saveProjects";
   static const String DISABLE_PROJECT= "Projects/disableProjects";
   static const String ENABLE_PROJECT= "Projects/enableProjects";

  //Project Time Sheet
   static const String SAVE_TIME_SHEET= "TimeSheet/saveTimeSheet";
   static const String GET_TIME_SHEET_REPORTS_LIST= "TimeSheet/getTimeSheetReport";

  //EmployeeCheckIns
   static const String GET_EMPLOYEE_CHECKIN_LIST= "EmployeeCheckIns/getEmployeeCheckInList";

  //AppAdmin
   static const String GET_COUNTRY_LIST = "Country/getCountryList";
   static const String GET_STATE_LIST = "State/getStateList";
   static const String GET_CITY_LIST = "City/getCityList";
}
