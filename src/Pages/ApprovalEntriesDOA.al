page 60186 "AppEntriesDOA"
{
    PageType = API;
    Caption = 'ApprovalEntry';
    APIPublisher = 'GSS';
    APIGroup = 'ApprovalEntry';
    APIVersion = 'v1.0';
    EntityName = 'ApprovalEntry';
    EntitySetName = 'ApprovalEntry';
    SourceTable = "Approval Entry";
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = where(status = filter(Open | Created));
    Permissions = tabledata "Approval Entry" = RIM, tabledata "Purchase Header" = RIM, tabledata "Sales Header" = RIM, tabledata "Job" = RIM;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Entry_No; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Table_ID; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field(Approval_Code; Rec."Approval Code")
                {
                    ApplicationArea = All;
                }
                field(Document_Type; DocType)
                {
                    ApplicationArea = All;
                }
                field(Document_No; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(documentNo; DocNo)
                {
                    ApplicationArea = All;
                }


                field(Sequence_No; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
                field(Sender_ID; Rec."Sender ID")
                {
                    ApplicationArea = All;
                }
                field(Approver_ID; Rec."Approver ID")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Date_Time_Sent_for_Approval; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field(Due_Date; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field(Last_Date_Time_Modified; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                }
                field(Last_Modified_By_User_ID; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                }
                field(Overdue; Rec.IsOverdue)
                {
                    ApplicationArea = All;
                }
                field(Record_ID_to_Approve; Rec."Record ID to Approve")
                {
                    ApplicationArea = All;
                }
                field(Pending_Approvals; Rec."Pending Approvals")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Date__Sent_for_Approval; DT2Date(Rec."Date-Time Sent for Approval"))
                {
                    ApplicationArea = All;
                }
                field(Approval_Comment; Rec.Approval_Comment)
                {
                    ApplicationArea = All;
                }
                field(DocumentDate; DocDate)
                {
                    ApplicationArea = All;
                }
                field(Notified; Rec.Notified)
                {
                    ApplicationArea = All;
                }
                field(ApproverEmail; ApproverEmail) { ApplicationArea = All; }
                field(SenderEmail; SenderEmail) { ApplicationArea = All; }
                field(CustomerName; CustomerName) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Salesperson; Salesperson) { ApplicationArea = All; }
                field(OrderAmount; OrderAmount) { ApplicationArea = All; }
                field(GP; GP) { ApplicationArea = All; }
                field(GPPercent; GPPercent) { ApplicationArea = All; }
                field(CurrencyCode; CurrCode) { ApplicationArea = All; }

                field(deliveryPromiseDate; DeliveryPromiseDate)
                {
                    ApplicationArea = All;
                }

                field(paymentTermCode; PaymentTermCode)
                {
                    ApplicationArea = All;
                }

                field(paymentTermDescription; PaymentTermDescription)
                {
                    ApplicationArea = All;
                }

                field(CreditlimitInsurance; CreditlimitInsurance)
                {
                    ApplicationArea = All;
                    Caption = 'Credit limit (Insurance)';
                }
                field(CreditLimitInternal; CreditLimitInternal)
                {
                    ApplicationArea = All;
                    Caption = 'Credit limit (Internal)';
                }
                field(Dueamount; Dueamount)
                {
                    ApplicationArea = All;
                    Caption = 'Due amount';

                }
                field(Totalutilized; Totalutilized)
                {
                    ApplicationArea = All;
                    Caption = 'Total Utilized';

                }
                field(Ballimitavailable; Ballimitavailable)
                {
                    ApplicationArea = All;
                    Caption = 'Balance limit available';

                }
                field("Reasonforapproval"; AllComments)
                {
                    Caption = 'Reason for approval';
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                }

                field(VendorName; VendorName)
                {
                    ApplicationArea = All;
                }
                field(JobNo; JobNo)
                {
                    ApplicationArea = All;
                }
                field(POType; POType)
                {
                    ApplicationArea = All;
                }
                field(purchaseCode; purchaseCode)
                {
                    ApplicationArea = All;
                }
                field(VendorCreditmemoNo; VendorCreditmemoNo)
                {
                    ApplicationArea = All;
                }
                // field(AllComments; AllComments)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Comments JSON';
                //     Editable = false;
                //     MultiLine = true;
                // }

                field(customerAdd; customerAdd)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Address';
                }
                field(CountryName; CountryName)
                {
                    ApplicationArea = All;
                    Caption = 'Country';
                }
                field(CustmerCreditLimit; CustmerCreditLimit)
                {
                    ApplicationArea = All;
                    Caption = 'Custmer Credit Limit';
                }
                field(OldCreditLimit; OldCreditLimit)
                {
                    ApplicationArea = All;
                    Caption = 'Old Credit Limit';
                }
                field(DifferenceinLimit; DifferenceinLimit)
                {
                    ApplicationArea = All;
                    Caption = 'Difference in Limit';
                }
                field(CustCreditLimitInsurance; CustCreditLimitInsurance)
                {
                    ApplicationArea = All;
                    Caption = 'Credit Limit (Insurance)';
                }
                field(CustCrdLimitIncReFno; CustCrdLimitIncReFno)
                {
                    ApplicationArea = All;
                    Caption = 'Credit Limit (Insurance Ref No)';
                }
                field(ReasonforCreditchange; ReasonforCreditchange)
                {
                    ApplicationArea = All;
                    Caption = 'Reason for Credit change';
                }
                field(Team; Team)
                {
                    ApplicationArea = All;
                    Caption = 'Team';
                }
                field(DueDays; DueDays)
                {
                    ApplicationArea = All;
                    Caption = 'Due days';
                    Editable = false;
                    ToolTip = 'Specifies the number of days the oldest outstanding invoice is overdue.';
                }

                field(TotalUtilizedInvoiced; TotalUtilizedInvoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Total Utilized (Total Outstanding Invoiced)';
                    Editable = false;
                    ToolTip = 'Specifies the total outstanding invoiced amount in LCY.';
                }

                field(TotalUtilizedPendingInvoice; TotalUtilizedPendingInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Total Utilized (Pending to Invoice)';
                    Editable = false;
                    ToolTip = 'Specifies the total amount pending to invoice from billable lines.';
                }
                field(ReasonforReturn; ReasonforReturn)
                {
                    ApplicationArea = all;
                    Caption = 'Reason for Return';
                }
                field(CustomerNo; CustomerNo)
                {
                    ApplicationArea = all;
                    Caption = 'Customer No.';
                }
                field(VendorNo; VendorNo)
                {
                    ApplicationArea = all;
                    Caption = 'Vendor No.';
                }
                field(Approvedpaymentterms; Approvedpaymentterms)
                {
                    ApplicationArea = all;
                    Caption = 'Approved payment terms';
                }
                field(Reasonforrequestingapproval; WorkflowConditions)
                {
                    ApplicationArea = All;
                    Caption = 'Reason for requesting approval';
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        RecRef: RecordRef;
        Job: Record Job;
        JobPlanningLine: Record "Job Planning Line";
    begin
        Clear(DocDate);
        Clear(CustomerName);
        Clear(Description);
        Clear(Salesperson);
        Clear(OrderAmount);
        Clear(GP);
        Clear(GPPercent);
        Clear(CurrCode);
        Clear(ApproverEmail);
        Clear(SenderEmail);
        Clear(DocType);
        clear(DocNo);
        Clear(VendorName);
        Clear(JobNo);
        Clear(POType);
        Clear(purchaseCode);
        Clear(Approvedpaymentterms);
        GenLedSetup.Get();

        // PurHdr.SetRange("No.", Rec."Document No.");
        // if PurHdr.FindFirst() then begin
        //     DocDate := PurHdr."Document Date";
        // end;
        // SalHdr.Reset();
        // SalHdr.SetRange("No.", Rec."Document No.");
        // if SalHdr.FindFirst() then begin
        //     DocDate := SalHdr."Document Date";
        // end;

        if ApproverUserSetup.Get(Rec."Approver ID") then
            ApproverEmail := ApproverUserSetup."E-Mail";
        if SenderUserSetup.Get(Rec."Sender ID") then
            SenderEmail := SenderUserSetup."E-Mail";
        case Rec."Table ID" of
            167:
                begin
                    RecRef.Get(Rec."Record ID to Approve");
                    RecRef.SetTable(Job);
                    // if Job.Get(Rec."Document No.") then begin
                    WorkflowConditions := GetWorkflowConditions(Rec."Workflow Step Instance ID");
                    Job.CalcFields("GSSTotal Budgeted Price");

                    DocNo := Job."No.";

                    ////1
                    Rec."Document No." := Job."No.";

                    CustomerName := Job."Sell-to Customer Name";
                    Description := Job."Search Description";
                    OrderAmount := Job."GSSTotal Budgeted Price";
                    GP := Job."GSSGross Margin";
                    GPPercent := Job."GSSGross Margin %";
                    if SalespersonRec.Get(Job."GSSSalesperson Code") then
                        Salesperson := SalespersonRec.Name;

                    Team := Job.GSSTeam;
                    if Job."Currency Code" = '' then
                        CurrCode := GenLedSetup."LCY Code"
                    else
                        CurrCode := Job."Currency Code";
                    // end;

                    DocType := 'JOB';
                    Job.CalcFields(Cust_CreditInsuranceLimitLCY);
                    Job.CalcFields(Cust_CreditLimitLCY);

                    CreditlimitInsurance := Job.Cust_CreditInsuranceLimitLCY;
                    CreditLimitInternal := Job.Cust_CreditLimitLCY;

                    Clear(BalDueLCY);
                    Clear(DueDays);
                    Clear(OldestDueDate);
                    Clear(TotalUtilizedInvoiced);
                    Clear(TotalUtilizedPendingInvoice);
                    DetCustLedEntries2.Reset();
                    DetCustLedEntries2.SetRange("Customer No.", Job."Sell-to Customer No.");
                    DetCustLedEntries2.SetFilter("Initial Entry Due Date", '..%1', Today);
                    if DetCustLedEntries2.FindSet() then begin
                        DetCustLedEntries2.CalcSums("Amount (LCY)");
                        BalDueLCY := DetCustLedEntries2."Amount (LCY)";
                    end;
                    dueamount := BalDueLCY;
                    if CustomerRec1.Get(Job."Sell-to Customer No.") then begin

                        CustomerRec1.CalcFields("Balance Due (LCY)");
                        TotalUtilizedInvoiced := CustomerRec1."Balance Due (LCY)";
                        Approvedpaymentterms := CustomerRec1."Payment Terms Code";

                        CustLedgEntry.Reset();
                        CustLedgEntry.SetRange(
                            "Customer No.", Job."Sell-to Customer No.");
                        CustLedgEntry.SetRange(Open, true);
                        CustLedgEntry.SetRange(
                            "Document Type",
                            CustLedgEntry."Document Type"::Invoice);
                        CustLedgEntry.SetFilter("Due Date", '<%1', Today());
                        if CustLedgEntry.FindSet() then
                            repeat
                                if (CustLedgEntry."Due Date" <> 0D) and
                                   ((OldestDueDate = 0D) or
                                    (CustLedgEntry."Due Date" < OldestDueDate))
                                then
                                    OldestDueDate := CustLedgEntry."Due Date";
                            until CustLedgEntry.Next() = 0;
                        if OldestDueDate <> 0D then
                            DueDays := Today() - OldestDueDate;
                    end;


                    //   Totalutilized := job."Sales Value" - OrderAmount;
                    //Ballimitavailable := Job.Cust_CreditLimitLCY - OrderAmount;

                    JobRec.Reset();
                    JobRec.SetRange("Sell-to Customer No.", Job."Sell-to Customer No.");
                    JobRec.SetRange("No.", DocNo);
                    if JobRec.FindSet() then
                        repeat
                            JobRec.CalcFields("GSSTotal Billable Price");
                            Clear(PendingInvoiceLCY);
                            JobTaskRec.Reset();
                            JobTaskRec.SetRange("Job No.", JobRec."No.");
                            if JobTaskRec.FindSet() then
                                repeat
                                    JobTaskRec.CalcFields("Contract (Invoiced Price)");
                                    PendingInvoiceLCY += JobTaskRec."Contract (Invoiced Price)";
                                until JobTaskRec.Next() = 0;
                        //TotalUtilizedPendingInvoice += JobRec."GSSTotal Billable Price" - PendingInvoiceLCY;
                        until JobRec.Next() = 0;

                    TotalUtilizedPendingInvoice := Job."Sales Value" - Job.Cust_BalanceLCY; //Wrong variable used for job table.

                    Totalutilized := TotalUtilizedInvoiced + TotalUtilizedPendingInvoice;


                    Ballimitavailable := Job.Cust_CreditLimitLCY - TotalUtilizedInvoiced - TotalUtilizedPendingInvoice;//Wrong variable used for job table.

                    JobPlanningLine.Reset();
                    JobPlanningLine.SetRange("Job No.", Job."No.");
                    if JobPlanningLine.FindFirst() then begin
                        DeliveryPromiseDate :=
                            JobPlanningLine."Planned Delivery Date";
                        DocDate := JobPlanningLine."Document Date";
                    end;



                    JobPlanningLine.Reset();
                    JobPlanningLine.SetRange("Job No.", Job."No.");
                    if JobPlanningLine.FindFirst() then begin
                        DeliveryPromiseDate := JobPlanningLine."Planned Delivery Date";
                        DocDate := JobPlanningLine."Document Date";
                    end;

                    PaymentTerms.Reset();
                    PaymentTerms.SetRange(Code, Job."Payment Terms Code");
                    if PaymentTerms.FindFirst() then begin
                        PaymentTermCode := PaymentTerms.Code;
                        PaymentTermDescription := PaymentTerms.Description;
                    end;

                    Clear(JsonArray);
                    Clear(JsonObject);
                    AllComments := '';

                    CycleStart := Rec."Date-Time Sent for Approval";
                    CycleEntry.Reset();
                    CycleEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                    CycleEntry.SetFilter(Status, '%1|%2', CycleEntry.Status::Open, CycleEntry.Status::Created);
                    if CycleEntry.FindSet() then
                        repeat
                            if CycleEntry."Date-Time Sent for Approval" < CycleStart then
                                CycleStart := CycleEntry."Date-Time Sent for Approval";
                        until CycleEntry.Next() = 0;

                    CommentLine.Reset();
                    CommentLine.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                    CommentLine.SetFilter("Date and Time", '>=%1', CycleStart);
                    CommentLine.SetCurrentKey("Date and Time");
                    if CommentLine.FindSet() then
                        repeat
                            if CommentLine.Comment <> '' then begin
                                Clear(JsonObject);
                                JsonObject.Add('userId', CommentLine."User ID");
                                JsonObject.Add('comment', CommentLine.Comment);
                                JsonArray.Add(JsonObject);
                            end;
                        until CommentLine.Next() = 0;

                    JsonArray.WriteTo(AllComments);
                end;
        end;
        case Rec."Table ID" of
            38:
                begin
                    if RecRef.Get(Rec."Record ID to Approve") then begin
                        RecRef.SetTable(PurchaseHeader);
                        case PurchaseHeader."Document Type" of
                            PurchaseHeader."Document Type"::Order:
                                DocType := 'PURCHASE ORDER';

                            PurchaseHeader."Document Type"::"Return Order":
                                DocType := 'PURCHASE RETURN ORDER';

                            else
                                DocType := Format(PurchaseHeader."Document Type");
                        end;

                        DocNo := PurchaseHeader."No.";
                        DocDate := PurchaseHeader."Document Date";

                        ///2
                        Rec."Document No." := PurchaseHeader."No.";
                        PurchaseHeader.CalcFields("Customer Name");
                        VendorName := PurchaseHeader."Buy-from Vendor Name";
                        VendorNo := PurchaseHeader."Buy-from Vendor No.";
                        Description := PurchaseHeader."Posting Description";
                        PurchaseHeader.CalcFields(Amount);
                        OrderAmount := PurchaseHeader.Amount;

                        CurrCode := PurchaseHeader."Currency Code";
                        if CurrCode = '' then
                            CurrCode := GenLedSetup."LCY Code";
                        // GP := PurchaseHeader.origi;
                        //  GPPercent := PurchaseHeader."GSSGross Margin %";
                        if SalespersonRec.Get(PurchaseHeader."Purchaser Code") then
                            Salesperson := SalespersonRec.Name;
                        if PurchaseHeader."Currency Code" = '' then
                            CurrCode := GenLedSetup."LCY Code"
                        else
                            CurrCode := PurchaseHeader."Currency Code";



                        POType := PurchaseHeader."PO Type";
                        if PurchaseHeader."PO Type" = PurchaseHeader."PO Type"::"PO-B2B" then begin
                            JobNo := PurchaseHeader."GSSJob No.";
                            CustomerName := PurchaseHeader."Customer Name";
                        end
                        else begin
                            JobNo := '';
                            CustomerName := '';
                        end;

                        purchaseCode := PurchaseHeader."Purchaser Code";
                        VendorCreditmemoNo := PurchaseHeader."Vendor Cr. Memo No.";
                        JobPlanningLine.Reset();
                        JobPlanningLine.SetRange("Job No.", PurchaseHeader."GSSJob No.");
                        if JobPlanningLine.FindFirst() then
                            DeliveryPromiseDate := JobPlanningLine."Planned Delivery Date";

                        PaymentTerms.Reset();
                        PaymentTerms.SetRange(Code, PurchaseHeader."Payment Terms Code");
                        if PaymentTerms.FindFirst() then begin
                            PaymentTermCode := PaymentTerms.Code;
                            PaymentTermDescription := PaymentTerms.Description;
                        end;


                        Clear(JsonArray);
                        Clear(JsonObject);
                        AllComments := '';

                        CycleStart := Rec."Date-Time Sent for Approval";
                        CycleEntry.Reset();
                        CycleEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                        CycleEntry.SetFilter(Status, '%1|%2', CycleEntry.Status::Open, CycleEntry.Status::Created);
                        if CycleEntry.FindSet() then
                            repeat
                                if CycleEntry."Date-Time Sent for Approval" < CycleStart then
                                    CycleStart := CycleEntry."Date-Time Sent for Approval";
                            until CycleEntry.Next() = 0;

                        CommentLine.Reset();
                        CommentLine.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                        CommentLine.SetFilter("Date and Time", '>=%1', CycleStart);
                        CommentLine.SetCurrentKey("Date and Time");
                        if CommentLine.FindSet() then
                            repeat
                                if CommentLine.Comment <> '' then begin
                                    Clear(JsonObject);
                                    JsonObject.Add('userId', CommentLine."User ID");
                                    JsonObject.Add('comment', CommentLine.Comment);
                                    JsonArray.Add(JsonObject);
                                end;
                            until CommentLine.Next() = 0;

                        JsonArray.WriteTo(AllComments);
                    end;
                end;
        end;
        case Rec."Table ID" of
            36:
                if RecRef.Get(Rec."Record ID to Approve") then begin
                    RecRef.SetTable(SalesHeader);
                    case SalesHeader."Document Type" of
                        SalesHeader."Document Type"::"Return Order":
                            DocType := 'SALES RETURN ORDER';
                    end;

                    DocNo := SalesHeader."No.";
                    DocDate := SalesHeader."Document Date";

                    ////3
                    Rec."Document No." := SalesHeader."No.";

                    CustomerName :=
                        SalesHeader."Sell-to Customer Name";
                    CustomerNo := SalesHeader."Sell-to Customer No.";

                    Description := SalesHeader."Posting Description";
                    ReasonforReturn := SalesHeader."Reason For Retun";
                    SalesHeader.CalcFields(Amount);
                    OrderAmount := SalesHeader.Amount;
                    GP := SalesHeader."GSSGross Margin";
                    GPPercent := SalesHeader."GSSGross Margin %";
                    CurrCode := SalesHeader."Currency Code";
                    Team := SalesHeader.GSSTeam;
                    if CurrCode = '' then
                        CurrCode := GenLedSetup."LCY Code";
                    if SalespersonRec.Get(SalesHeader."Salesperson Code") then
                        Salesperson := SalespersonRec.Name;

                    JobPlanningLine.Reset();
                    JobPlanningLine.SetRange("Job No.", SalesHeader."GSSJob No.");
                    if JobPlanningLine.FindFirst() then
                        DeliveryPromiseDate := JobPlanningLine."Planned Delivery Date";

                    PaymentTerms.Reset();
                    PaymentTerms.SetRange(Code, SalesHeader."Payment Terms Code");
                    if PaymentTerms.FindFirst() then begin
                        PaymentTermCode := PaymentTerms.Code;
                        PaymentTermDescription := PaymentTerms.Description;
                    end;


                    Clear(JsonArray);
                    Clear(JsonObject);
                    AllComments := '';

                    CycleStart := Rec."Date-Time Sent for Approval";
                    CycleEntry.Reset();
                    CycleEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                    CycleEntry.SetFilter(Status, '%1|%2', CycleEntry.Status::Open, CycleEntry.Status::Created);
                    if CycleEntry.FindSet() then
                        repeat
                            if CycleEntry."Date-Time Sent for Approval" < CycleStart then
                                CycleStart := CycleEntry."Date-Time Sent for Approval";
                        until CycleEntry.Next() = 0;

                    CommentLine.Reset();
                    CommentLine.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                    CommentLine.SetFilter("Date and Time", '>=%1', CycleStart);
                    CommentLine.SetCurrentKey("Date and Time");
                    if CommentLine.FindSet() then
                        repeat
                            if CommentLine.Comment <> '' then begin
                                Clear(JsonObject);
                                JsonObject.Add('userId', CommentLine."User ID");
                                JsonObject.Add('comment', CommentLine.Comment);
                                JsonArray.Add(JsonObject);
                            end;
                        until CommentLine.Next() = 0;

                    JsonArray.WriteTo(AllComments);
                end;
        end;
        case Rec."Table ID" of
            18:
                begin
                    if RecRef.Get(Rec."Record ID to Approve") then begin
                        RecRef.SetTable(CustomerRec);

                        // Document details
                        DocType := 'CUSTOMER';
                        DocNo := CustomerRec."No.";
                        Rec."Document No." := CustomerRec."No.";
                        CustomerNo := CustomerRec."No.";

                        // Customer information
                        CustomerName := CustomerRec.Name;
                        Description := CustomerRec.Address;

                        // Credit limit details
                        OrderAmount := CustomerRec."Credit Limit (LCY)";
                        CustmerCreditLimit := CustomerRec."Credit Limit (LCY)";
                        customerAdd := CustomerRec.Address + ',' + CustomerRec."Address 2" + ',' + CustomerRec.City;
                        OldCreditLimit := CustomerRec."Old Credit Limit";
                        DifferenceinLimit := CustomerRec."Credit Limit Difference";
                        CustCreditLimitInsurance := CustomerRec."Insurance Credit Limit";
                        CustCrdLimitIncReFno := CustomerRec."Insurance Ref no";
                        ReasonforCreditchange := CustomerRec."Reason for Credit Change";
                        Team := CustomerRec.GSSTeam;
                        Clear(CountryName);
                        CountryRegion.Reset();
                        CountryRegion.SetRange(Code, CustomerRec."Country/Region Code");
                        if CountryRegion.FindFirst() then
                            CountryName := CountryRegion.Name;

                        // Salesperson
                        if SalespersonRec.Get(CustomerRec."Salesperson Code") then
                            Salesperson := SalespersonRec.Name;

                        // Payment terms
                        PaymentTerms.Reset();
                        PaymentTerms.SetRange(Code, CustomerRec."Payment Terms Code");
                        if PaymentTerms.FindFirst() then begin
                            PaymentTermCode := PaymentTerms.Code;
                            PaymentTermDescription := PaymentTerms.Description;
                        end;

                        // Currency
                        CurrCode := GenLedSetup."LCY Code";

                        // Comments for the current approval cycle
                        Clear(JsonArray);
                        Clear(JsonObject);
                        AllComments := '';

                        CycleStart := Rec."Date-Time Sent for Approval";

                        CycleEntry.Reset();
                        CycleEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                        CycleEntry.SetFilter(Status, '%1|%2', CycleEntry.Status::Open, CycleEntry.Status::Created);
                        if CycleEntry.FindSet() then
                            repeat
                                if CycleEntry."Date-Time Sent for Approval" < CycleStart then
                                    CycleStart :=
                                        CycleEntry."Date-Time Sent for Approval";
                            until CycleEntry.Next() = 0;

                        CommentLine.Reset();
                        CommentLine.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                        CommentLine.SetFilter("Date and Time", '>=%1', CycleStart);
                        CommentLine.SetCurrentKey("Date and Time");
                        if CommentLine.FindSet() then
                            repeat
                                if CommentLine.Comment <> '' then begin
                                    Clear(JsonObject);
                                    JsonObject.Add('userId', CommentLine."User ID");
                                    JsonObject.Add('comment', CommentLine.Comment);
                                    JsonArray.Add(JsonObject);
                                end;
                            until CommentLine.Next() = 0;

                        JsonArray.WriteTo(AllComments);
                    end;
                end;
        end;
    end;


    var
        Approvedpaymentterms: Text;
        customerAdd: Text;
        CustomerNo: Code[20];
        VendorNo: Code[20];
        ReasonforReturn: Text;
        CustmerCreditLimit: Decimal;
        OldCreditLimit: Decimal;
        DifferenceinLimit: Decimal;
        CustCreditLimitInsurance: Decimal;
        CustCrdLimitIncReFno: code[20];
        ReasonforCreditchange: Text;
        Team: Code[10];
        CountryName: Text[50];
        CustomerRec1: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        OldestDueDate: Date;
        DueDays: Integer;
        TotalUtilizedInvoiced: Decimal;
        TotalUtilizedPendingInvoice: Decimal;
        PendingInvoiceLCY: Decimal;

        CountryRegion: Record "Country/Region";
        // CommentLine: Record "Approval Comment Line";

        CycleEntry: Record "Approval Entry";
        // TB: TextBuilder;
        CycleStart: DateTime;
        PurHdr: Record "Purchase Header";
        SalHdr:
                Record "Sales Header";
        SalespersonRec:
                Record "Salesperson/Purchaser";
        ApproverUserSetup:
                Record "User Setup";
        SenderUserSetup:
                Record "User Setup";
        Job:
                Record Job;
        GenLedSetup:
                Record "General Ledger Setup";
        PaymentTerms:
                Record "Payment Terms";
        DocNo:
                Code[20];
        DocDate:
                Date;
        CustomerName:
                Text[250];
        Description:
                Text[250];
        Salesperson:
                Text[100];
        OrderAmount:
                Decimal;
        GP:
                Decimal;
        GPPercent:
                Decimal;
        CurrCode:
                Code[20];
        ApproverEmail:
                Text[100];
        SenderEmail:
                Text[100];
        DocType:
                Text[50];
        DeliveryPromiseDate:
                Date;
        PaymentTermCode:
                Code[10];
        PaymentTermDescription:
                Text[100];
        ToApprove:
                Text[250];
        DateSentForApproval:
                Date;
        PurchaseHeader:
                Record "Purchase Header";
        SalesHeader:
                Record "Sales Header";
        CreditlimitInsurance:
                Decimal;
        CreditLimitInternal:
                Decimal;
        Dueamount:
                Decimal;
        Totalutilized:
                decimal;
        Ballimitavailable:
                Decimal;
        DetCustLedEntries2:
                Record "Detailed Cust. Ledg. Entry";
        BalDueLCY:
                Decimal;
        JobRec:
                Record Job;
        JobTaskRec:
                Record "Job Task";
        OrderValue:
                Decimal;
        TotalInvoicePrice:
                Decimal;
        CommentLine:
                Record "Approval Comment Line";
        TB:
                TextBuilder;
        RecordIdText:
                Text;
        AllComments:
                Text;
        JsonArray:
                JsonArray;
        JsonObject:
                JsonObject;
        JobNo:
                code[20];
        POType:
                Enum "PO Type";
        VendorName:
                Text[100];
        purchaseCode:
                code[20];
        VendorCreditmemoNo:
                Code[20];
        CustomerRec: Record Customer;
        WorkflowConditions: Text;

    local procedure GetWorkflowConditions(StepInstanceID: Guid): Text
    var
        WFStepInstance: Record "Workflow Step Instance";
        WFStep: Record "Workflow Step";
        WFStepArg: Record "Workflow Step Argument";
        Job: Record Job;
        XmlDoc: XmlDocument;
        NodeList: XmlNodeList;
        DataItemNode: XmlNode;
        NameAttr: XmlAttribute;
        FilterXml: Text;
        ViewText: Text;
        TableName: Text;
        FilterText: Text;
        Result: Text;
        IsJobItem: Boolean;
        WFStepInstanceArchive: Record "Workflow Step Instance Archive";
        OriginalWorkflowCode: Code[20];
    begin
        if IsNullGuid(StepInstanceID) then
            exit('');

        WFStepInstance.Reset();
        WFStepInstance.SetRange(ID, StepInstanceID);
        WFStepInstance.SetRange(Status, WFStepInstance.Status::Active);
        if WFStepInstance.FindFirst() then
            OriginalWorkflowCode := WFStepInstance."Original Workflow Code"
        else begin
            WFStepInstanceArchive.Reset();
            WFStepInstanceArchive.SetRange(ID, StepInstanceID);
            if not WFStepInstanceArchive.FindFirst() then
                exit('');
            OriginalWorkflowCode := WFStepInstanceArchive."Original Workflow Code";
        end;

        WFStep.Reset();
        WFStep.SetRange("Workflow Code", OriginalWorkflowCode);
        WFStep.SetRange("Entry Point", true);
        if not WFStep.FindFirst() then
            exit('');
        if IsNullGuid(WFStep.Argument) then
            exit('');
        if not WFStepArg.Get(WFStep.Argument) then
            exit('');

        FilterXml := WFStepArg.GetEventFilters();
        if FilterXml = '' then
            exit('');
        if not XmlDocument.ReadFrom(FilterXml, XmlDoc) then
            exit('');
        if not XmlDoc.SelectNodes('//DataItem', NodeList) then
            exit('');
        foreach DataItemNode in NodeList do begin
            // Accept the Job data item by name ("Job") or by table id ("Table167")
            IsJobItem := true;
            if DataItemNode.AsXmlElement().Attributes().Get('name', NameAttr) then begin
                TableName := NameAttr.Value();
                IsJobItem :=
                  (TableName = '') or
                  (TableName = Job.TableName()) or
                  (TableName = 'Table' + Format(Database::Job));
            end;
            if IsJobItem then begin
                ViewText := DataItemNode.AsXmlElement().InnerText();
                if ViewText <> '' then begin
                    FilterText := '';
                    if TryGetJobFilters(ViewText, FilterText) then
                        if FilterText <> '' then begin
                            if Result <> '' then
                                Result += ' | ';
                            Result += FilterText;
                        end;
                end;
            end;
        end;

        exit(Result);
    end;

    [TryFunction]
    local procedure TryGetJobFilters(ViewText: Text; var FilterText: Text)
    var
        JobFilter: Record Job;
    begin
        JobFilter.Reset();
        JobFilter.SetView(ViewText);
        FilterText := JobFilter.GetFilters();
    end;
}