codeunit 60106 "GSSJob Document Class"
{
    procedure PerformManualRelease(var Job: Record Job)
    begin
        OnBeforeManualReleaseJobDoc(Job, PreviewMode);
        PerformManualCheckAndRelease(Job);
        OnAfterManualReleaseJobDoc(Job, PreviewMode);
    end;

    local procedure ValidateBeforeRelease(var Job: Record Job)
    begin
        Job.TestSalespersonCode();
        Job.TestField("Project Manager");
        Job.TestField("Person Responsible");
        Job.TestField("Invoice Currency Code");
    end;

    procedure PerformManualCheckAndRelease(var Job: Record Job)
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        IsHandled: Boolean;
    begin
        if Job.GSSStatus = job.GSSStatus::Released then
            exit;
        IsHandled := false;
        OnBeforePerformManualCheckAndRelease(Job, PreviewMode, IsHandled);
        if IsHandled then
            exit;
        if Job.GSSStatus = Job.GSSStatus::"Pending Approval" then
            Error(Text003);
        ValidateBeforeRelease(Job);
        UpdateGrossMarginForJob(Job);
        CheckJobPendingApproval(Job);
        IsHandled := false;
        OnBeforePerformManualRelease(Job, PreviewMode, IsHandled);
        if IsHandled then
            exit;
        // CODEUNIT.Run(CODEUNIT::"Release Sales Document", Job);
        Release(Job);
        OnAfterPerformManualCheckAndRelease(Job, PreviewMode);
    end;

    procedure PerformManualReopen(var Job: Record Job)
    begin
        CheckReopenStatus(Job);
        OnBeforeManualReOpenJobDoc(Job, PreviewMode);
        Reopen(Job);
        OnAfterManualReOpenJobDoc(Job, PreviewMode);
    end;

    local procedure CheckReopenStatus(Job: Record Job)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckReopenStatus(Job, IsHandled);
        if IsHandled then
            exit;
        if Job.GSSStatus = Job.GSSStatus::"Pending Approval" then
            Error(Text003);
    end;

    procedure Reopen(var Job: Record Job)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeReopenJobDoc(Job, PreviewMode, IsHandled);
        if IsHandled then
            exit;
        if Job.GSSStatus = Job.GSSStatus::Open then
            exit;
        Job.GSSStatus := Job.GSSStatus::Open;
        OnReopenOnBeforeJobDocModify(Job);
        Job.Modify(true);
        OnAfterReopenJobDoc(Job, PreviewMode);
    end;

    procedure SetStatusToPendingApproval(var Job: Record Job)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetStatusToPendingApprovalJobDoc(Job, PreviewMode, IsHandled);
        if IsHandled then
            exit;
        if Job.GSSStatus = Job.GSSStatus::"Pending Approval" then
            exit;
        Job.GSSStatus := Job.GSSStatus::"Pending Approval";
        OnSetStatusToPendingApprovalOnBeforeJobDocModify(Job);
        Job.Modify(true);
        OnAfterSetStatusToPendingApprovalJobDoc(Job, PreviewMode);
    end;

    procedure Release(var Job: Record Job)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeReleaseJobDoc(Job, PreviewMode, IsHandled);
        if IsHandled then
            exit;
        if Job.GSSStatus = Job.GSSStatus::Released then
            exit;
        Job.GSSStatus := Job.GSSStatus::Released;
        OnReleaseOnBeforeJobDocModify(Job);
        Job.Modify(true);
        OnAfterReleaseJobDoc(Job, PreviewMode);
    end;

    local procedure CheckJobPendingApproval(var Job: Record Job)
    var
        ApprovalsMgmt: Codeunit GSSApprovalMgt;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckJobPendingApproval(Job, IsHandled);
        if IsHandled then
            exit;
        if ApprovalsMgmt.IsJobPendingApproval(Job) then
            Error(Text002);
    end;

    procedure UpdateGrossMarginForJob(var Job: Record Job)
    var
        CustomerRec: Record Customer;
        // [SecurityFiltering(SecurityFilter::Filtered)]
        JobRec: Record Job;
        // [SecurityFiltering(SecurityFilter::Filtered)]
        JobTaskRec: Record "Job Task";
        OrderValue: Decimal;
        TotalInvoicePrice: Decimal;
        // [SecurityFiltering(SecurityFilter::Filtered)]
        CurrJobTask: Record "Job Task";
        CurrInvoicePrice: Decimal;
        CurrentOrderValue: Decimal;
    begin
        //updating gross profit
        //CH
        Clear(OrderValue);
        Clear(TotalInvoicePrice);
        Clear(CurrInvoicePrice);
        Clear(CurrentOrderValue);
        Job.CalcFields("GSSTotal Billable Price", "GSSTotal Budgeted Price");
        //TODO: a condition should be added to check if budgeted price and billabe price should be same.
        if Job."GSSCustomer PO Amount" <> Job."GSSTotal Billable Price" then
            Error('Purchase Order Amount should be equal to Total Billable Price.');
        if Job."GSSCustomer PO Amount" <> Job."GSSTotal Budgeted Price" then
            Error('Purchase Order Amount should be equal to Total Budgeted Price.');
        //CH
        Job.CalcFields("GSSTotal Budgeted Cost", "GSSTotal Billable Price");
        Job."GSSGross Margin" := job."GSSTotal Billable Price" - Job."GSSTotal Budgeted Cost";
        if Job."GSSTotal Billable Price" <> 0 then
            Job."GSSGross Margin %" := Round((Job."GSSTotal Billable Price" - Job."GSSTotal Budgeted Cost") * 100 / Job."GSSTotal Billable Price", 0.1)
        else
            Job."GSSGross Margin %" := 0;
        JobRec.Setrange("Sell-to Customer No.", Job."Bill-to Customer No.");
        JobRec.SetFilter(GSSStatus, '%1|%2', JobRec.GSSStatus::"Pending Approval", JobRec.GSSStatus::Released);
        if JobRec.FindSet() then
            repeat
                JobRec.CalcFields("GSSTotal Billable Price");
                Clear(TotalInvoicePrice);
                JobTaskRec.Reset();
                JobTaskRec.SetRange("Job No.", JobRec."No.");
                if JobTaskRec.FindSet() then
                    repeat
                        JobTaskRec.CalcFields("Contract (Invoiced Price)");
                        TotalInvoicePrice += JobTaskRec."Contract (Invoiced Price)";
                    until JobTaskRec.Next() = 0;
                OrderValue += (JobRec."GSSTotal Billable Price" - TotalInvoicePrice);
            until JobRec.Next() = 0;
        CurrJobTask.Reset();
        CurrJobTask.SetRange("Job No.", Job."No.");
        if CurrJobTask.FindSet() then
            repeat
                CurrJobTask.CalcFields("Contract (Invoiced Price)");
                CurrInvoicePrice += CurrJobTask."Contract (Invoiced Price)";
            until CurrJobTask.Next() = 0;
        CurrentOrderValue := Job."GSSTotal Billable Price" - CurrInvoicePrice;
        if CustomerRec.Get(Job."Sell-to Customer No.") then begin
            CustomerRec.CalcFields("Balance (LCY)");
            Job."Customer Credit Limit" := CustomerRec."Credit Limit (LCY)";
            Job."Sales Value" := CustomerRec."Balance (LCY)" + OrderValue + CurrentOrderValue;

            ///Rk 031126
            Job."Credit Exposure" := CalcCreditExposure(Job);

            //  Job."Invoice Value" := CustomerRec."Balance (LCY)" + CurrentInvoiceValue;
            //   Job."Shipment Value" := CustomerRec."Balance (LCY)" + CurrentDeliveryValue + DeliverdNotInvoiced;
            if ((CustomerRec."Balance (LCY)" + OrderValue + CurrentOrderValue) > (CustomerRec."Credit Limit (LCY)")) then
                Job."Need Finance Approval" := true;
        end;
        Job.Modify();
    end;

    local procedure CalcCreditExposure(var Job: Record Job): Decimal
    var
        Customer: Record Customer;
        TotalOutstandingInvoiced: Decimal;
        TotalPendingInvoice: Decimal;
    begin
        Clear(TotalOutstandingInvoiced);
        Clear(TotalPendingInvoice);
        Customer.Reset();
        Customer.SetRange("No.", Job."Sell-to Customer No.");
        if Customer.FindFirst() then begin
            Customer.CalcFields("Balance (LCY)");
            TotalOutstandingInvoiced := Customer."Balance (LCY)";
        end;

        TotalPendingInvoice := Job."Sales Value" - Job.Cust_BalanceLCY;

        exit(
            Job.Cust_CreditLimitLCY -
            TotalOutstandingInvoiced -
            TotalPendingInvoice
        );
    end;

    procedure UpdateSalesValue(var Job: Record Job)
    var
        CustomerRec: Record Customer;
        JobRec: Record Job;
        JobTaskRec: Record "Job Task";
        OrderValue: Decimal;
        TotalInvoicePrice: Decimal;
        CurrJobTask: Record "Job Task";
        CurrInvoicePrice: Decimal;
        CurrentOrderValue: Decimal;
    begin
        Clear(OrderValue);
        Clear(TotalInvoicePrice);
        Clear(CurrInvoicePrice);
        Clear(CurrentOrderValue);
        Job.CalcFields("GSSTotal Billable Price", "GSSTotal Budgeted Price");
        JobRec.Setrange("Sell-to Customer No.", Job."Bill-to Customer No.");
        JobRec.SetFilter(GSSStatus, '%1|%2', JobRec.GSSStatus::"Pending Approval", JobRec.GSSStatus::Released);
        if JobRec.FindSet() then
            repeat
                JobRec.CalcFields("GSSTotal Billable Price");
                Clear(TotalInvoicePrice);
                JobTaskRec.Reset();
                JobTaskRec.SetRange("Job No.", JobRec."No.");
                if JobTaskRec.FindSet() then
                    repeat
                        JobTaskRec.CalcFields("Contract (Invoiced Price)");
                        TotalInvoicePrice += JobTaskRec."Contract (Invoiced Price)";
                    until JobTaskRec.Next() = 0;
                OrderValue += (JobRec."GSSTotal Billable Price" - TotalInvoicePrice);
            until JobRec.Next() = 0;
        CurrJobTask.Reset();
        CurrJobTask.SetRange("Job No.", Job."No.");
        if CurrJobTask.FindSet() then
            repeat
                CurrJobTask.CalcFields("Contract (Invoiced Price)");
                CurrInvoicePrice += CurrJobTask."Contract (Invoiced Price)";
            until CurrJobTask.Next() = 0;
        CurrentOrderValue := Job."GSSTotal Billable Price" - CurrInvoicePrice;
        if CustomerRec.Get(Job."Sell-to Customer No.") then begin
            CustomerRec.CalcFields("Balance (LCY)");
            Job."Customer Credit Limit" := CustomerRec."Credit Limit (LCY)";
            Job."Sales Value" := CustomerRec."Balance (LCY)" + OrderValue + CurrentOrderValue;
            //  Job."Invoice Value" := CustomerRec."Balance (LCY)" + CurrentInvoiceValue;
            //   Job."Shipment Value" := CustomerRec."Balance (LCY)" + CurrentDeliveryValue + DeliverdNotInvoiced;
        end;
        Job.Modify();
    end;

    procedure UpdateInvoiceValue(SalesHeader: Record "Sales Header")
    var
        PaymentTermsRec: Record "Payment Terms";
        CurrLineVAT: Decimal;
        CurrSL: Record "Sales Line";
        CurrentInvoiceValue: Decimal;
        CustomerRec: Record Customer;
        JobRec: Record Job;
    begin
        Clear(CurrentInvoiceValue);
        Clear(CurrLineVAT);
        if JobRec.Get(SalesHeader."GSSJob No.") then;
        CurrSL.Reset();
        CurrSL.SetRange("Document No.", SalesHeader."No.");
        if CurrSL.FindSet() then
            repeat
                if ((SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0)) then
                    CurrLineVAT := ((((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") / SalesHeader."Currency Factor") * CurrSL."VAT %") / 100
                else
                    CurrLineVAT := (((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") * CurrSL."VAT %") / 100;
                if ((SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0)) then
                    CurrentInvoiceValue += (((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") / SalesHeader."Currency Factor") + CurrLineVAT
                else
                    CurrentInvoiceValue += ((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") + CurrLineVAT;
            until CurrSL.Next() = 0;
        if CustomerRec.Get(SalesHeader."Sell-to Customer No.") then begin
            CustomerRec.CalcFields("Balance (LCY)");
            JobRec."Invoice Value" := CustomerRec."Balance (LCY)" + CurrentInvoiceValue;
            JobRec.Modify();
        end;
    end;

    procedure TestJobStatusReleased(JobNo: code[20])
    var
        Job: Record Job;
    begin
        if Job.Get(JobNo) then
            Job.TestStatusReleased()
        else
            Error('Invalid Job No.: %1', JobNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GSSApprovalMgt, 'OnSendJobDocumentForApproval', '', false, false)]
    local procedure OnSendJobDocumentForApproval(var Job: Record Job)
    begin
        ValidateBeforeRelease(Job);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", 'OnBeforeModifySalesHeader', '', false, false)]
    local procedure GSS_OnBeforeModifySalesHeader(var SalesHeader: Record "Sales Header"; Job: Record Job; JobPlanningLine: Record "Job Planning Line")
    begin
        if Job."GSSSalesperson Code" <> '' then begin
            SalesHeader.Validate("Salesperson Code", Job."GSSSalesperson Code");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforePurchOrderHeaderInsert', '', false, false)]
    local procedure OnBeforePurchOrderHeaderInsert(var PurchaseHeader: Record "Purchase Header"; RequisitionLine: Record "Requisition Line")
    var
        Job: Record Job;
    begin
        if RequisitionLine."Demand Type" = 1003 then begin
            PurchaseHeader."GSSJob No." := RequisitionLine."Demand Order No.";
            if Job.Get(PurchaseHeader."GSSJob No.") then
                if Job."GSSPurchase Order No." <> '' then
                    PurchaseHeader."No." := Job."GSSPurchase Order No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterInsertPurchOrderHeader', '', false, false)]
    local procedure OnAfterInsertPurchOrderHeader(var RequisitionLine: Record "Requisition Line"; var PurchaseOrderHeader: Record "Purchase Header"; CommitIsSuppressed: Boolean; SpecialOrder: Boolean)
    var
        Job: Record Job;
    begin
        if RequisitionLine."Demand Type" = 1003 then begin
            if Job.Get(PurchaseOrderHeader."GSSJob No.") then begin
                if Job."GSSSalesperson Code" <> '' then
                    PurchaseOrderHeader.Validate("Purchaser Code", Job."GSSSalesperson Code");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Suggest Job Jnl. Lines", 'OnAfterTransferTimeSheetDetailToJobJnlLine', '', false, false)]
    local procedure OnAfterTransferTimeSheetDetailToJobJnlLine(var JobJournalLine: Record "Job Journal Line"; JobJournalTemplate: Record "Job Journal Template"; var TempTimeSheetLine: Record "Time Sheet Line" temporary; TimeSheetDetail: Record "Time Sheet Detail"; JobJournalBatch: Record "Job Journal Batch")
    var
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
    begin
        if JobJournalLine.Type <> JobJournalLine.Type::Resource then
            exit;
        if (JobJournalLine."Job No." <> '') and (JobJournalLine."Job Task No." <> '') then begin
            if JobTask.Get(JobJournalLine."Job No.", JobJournalLine."Job Task No.") then begin
                JobPlanningLine.SetCurrentKey("Job No.", "Job Task No.", "Line No.");
                JobPlanningLine.SetRange("Job No.", JobTask."Job No.");
                JobPlanningLine.SetRange("Job Task No.", JobTask."Job Task No.");
                JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
                JobPlanningLine.SetRange("No.", JobJournalLine."No.");
                if JobPlanningLine.FindFirst() then begin
                    JobJournalLine.Validate("Unit Cost", JobPlanningLine."Unit Cost");
                    JobJournalLine.Validate("Unit Price", JobPlanningLine."Unit Price");
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", 'OnCreateSalesHeaderOnBeforeUpdateSalesHeader', '', false, false)]
    local procedure OnCreateSalesHeaderOnBeforeUpdateSalesHeader(var SalesHeader: Record "Sales Header"; var Job: Record Job; var IsHandled: Boolean; JobPlanningLine: Record "Job Planning Line")
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then
            exit;
        if (Job."External Document No." <> '') and (SalesHeader."External Document No." = '') then
            SalesHeader.Validate("External Document No.", Job."External Document No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", 'OnCreateSalesInvoiceOnBeforeRunReport', '', false, false)]
    local procedure OnCreateSalesInvoiceOnBeforeRunReport(var JobPlanningLine: Record "Job Planning Line"; var Done: Boolean; var NewInvoice: Boolean; var PostingDate: Date; var InvoiceNo: Code[20]; var IsHandled: Boolean; CrMemo: Boolean)
    begin
        TestJobStatusReleased(JobPlanningLine."Job No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", 'OnBeforeCreateSalesInvoiceJobTask', '', false, false)]
    local procedure OnBeforeCreateSalesInvoiceJobTask(var JobTask2: Record "Job Task"; PostingDate: Date; InvoicePerTask: Boolean; var NoOfInvoices: Integer; var OldJobNo: Code[20]; var OldJobTaskNo: Code[20]; LastJobTask: Boolean; var IsHandled: Boolean)
    begin
        TestJobStatusReleased(JobTask2."Job No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Transfer Line", 'OnAfterFromPlanningLineToJnlLine', '', false, false)]
    local procedure OnAfterFromPlanningLineToJnlLine(var JobJournalLine: Record "Job Journal Line"; JobPlanningLine: Record "Job Planning Line")
    var
        JobJournalBatch: Record "Job Journal Batch";
        Job: Record Job;
    begin
        TestJobStatusReleased(JobPlanningLine."Job No.");
        //if posting number series is not defined on the lines.
        if JobJournalLine."Posting No. Series" = '' then
            if (JobJournalLine."Journal Template Name" <> '') and (JobJournalLine."Journal Batch Name" <> '') then
                if JobJournalBatch.Get(JobJournalLine."Journal Template Name", JobJournalLine."Journal Batch Name") then
                    if JobJournalBatch."Posting No. Series" <> '' then begin
                        JobJournalLine.Validate("Posting No. Series", JobJournalBatch."Posting No. Series");
                    end;
        // Ch
        If JobJournalLine."External Document No." = '' Then
            If Job.Get(JobPlanningLine."Job No.") then
                JobJournalLine."External Document No." := Job."External Document No.";
        //ch
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnAfterRunCode', '', false, false)]
    local procedure JobJnlPostLine_OnAfterRunCode(var JobJournalLine: Record "Job Journal Line"; var JobLedgEntryNo: Integer; var JobRegister: Record "Job Register"; var NextEntryNo: Integer)
    var
        JobRec: Record Job;
        JobLedEntryRec: Record "Job Ledger Entry";
    begin
        if JobLedEntryRec.Get(JobLedgEntryNo) then
            if JobRec.Get(JobLedEntryRec."Job No.") then
                if not JobRec."GSSWIP Calc. Required" then begin
                    JobRec."GSSWIP Calc. Required" := true;
                    JobRec.Modify(false);
                end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetStatusToPendingApprovalJobDoc(var Job: Record Job; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetStatusToPendingApprovalOnBeforeJobDocModify(var Job: Record Job)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetStatusToPendingApprovalJobDoc(var Job: Record Job; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReleaseJobDoc(var Job: Record Job; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenJobDoc(var Job: Record Job; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseJobDoc(var Job: Record Job; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenJobDoc(var Job: Record Job; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnReopenOnBeforeJobDocModify(var Job: Record Job)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnReleaseOnBeforeJobDocModify(var Job: Record Job)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckReopenStatus(Job: Record Job; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeManualReOpenJobDoc(var Job: Record Job; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterManualReOpenJobDoc(var Job: Record Job; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPerformManualCheckAndRelease(var Job: Record Job; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePerformManualRelease(var Job: Record Job; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeManualReleaseJobDoc(var Job: Record Job; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterManualReleaseJobDoc(var Job: Record Job; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePerformManualCheckAndRelease(var Job: Record Job; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPerformManualCheckAndReleaseOnBeforeJobModify(var Job: Record Job; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckJobPendingApproval(var Job: Record Job; var IsHandled: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Calculate WIP", 'OnBeforeCalcRecognizedSales', '', false, false)]
    local procedure OnBeforeCalcRecognizedSales(var JobTask: Record "Job Task"; var JobWIPTotal: Record "Job WIP Total"; var JobWIPMethod: Record "Job WIP Method"; var IsHandled: Boolean)
    var
        JobSetup: Record "Jobs Setup";
        WIPAmount: Decimal;
        RecognizedAllocationPercentage: Decimal;
    begin
        if not JobSetup.Get() then
            exit;
        if not JobSetup."GSSRecognised Sales By Dim." then
            exit;
        if JobWIPMethod."Recognized Sales" <> JobWIPMethod."Recognized Sales"::"Sales Value" then
            exit;
        JobTask."Recognized Sales Amount" := Round(JobTask."Usage (Total Price)");
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Job, 'OnBeforeRecalculateJobWIP', '', false, false)]
    local procedure OnBeforeRecalculateJobWIP(var Job: Record Job; var IsHandled: Boolean)
    begin
        if Job.Complete then
            IsHandled := true;
    end;
    //Customer--Contact Creation
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeCheckContactType', '', false, false)]
    local procedure OnBeforeCheckContactType(var Contact: Record Contact; ContactType: enum "Contact Type"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeTypeChange', '', false, false)]
    local procedure OnBeforeTypeChange(Contact: Record Contact; xContact: Record Contact; var InteractLogEntry: Record "Interaction Log Entry"; var Opp: Record Opportunity; var Task: Record "To-do"; var Cont: Record Contact; var IsHandled: Boolean)
    var
        RMSetup: Record "Marketing Setup";
        Text003: Label '%1 cannot be changed because one or more interaction log entries are linked to the contact.';
        Text006: Label '%1 cannot be changed because one or more opportunities are linked to the contact.';
        CampaignTargetGrMgt: Codeunit "Campaign Target Group Mgt";
        Text007: Label '%1 cannot be changed because there are one or more related people linked to the contact.';
        DuplMgt: Codeunit DuplicateManagement;
    begin
        IsHandled := true;
        //Type Change Error Removal
        with Contact do begin
            RMSetup.Get();
            if Type <> xContact.Type then begin
                InteractLogEntry.LockTable();
                Cont.LockTable();
                InteractLogEntry.SetCurrentKey("Contact Company No.", "Contact No.");
                InteractLogEntry.SetRange("Contact Company No.", "Company No.");
                InteractLogEntry.SetRange("Contact No.", "No.");
                //if InteractLogEntry.FindFirst() then
                //   Error(Text003, FieldCaption(Type));
                //  OnTypeChangeOnAfterCheckInteractionLog(Rec, xRec);
                /* Task.SetRange("Contact Company No.", "Company No.");
                Task.SetRange("Contact No.", "No.");
                if not Task.IsEmpty() then
                    Error(CannotChangeWithOpenTasksErr, FieldCaption(Type)); */
                //KK- Removed
                Opp.SetRange("Contact Company No.", "Company No.");
                Opp.SetRange("Contact No.", "No.");
                //if not Opp.IsEmpty() then
                //  Error(Text006, FieldCaption(Type));
            end;
            case Type of
                Type::Company:
                    begin
                        if Type <> xContact.Type then begin
                            TestField("Organizational Level Code", '');
                            TestField("No. of Job Responsibilities", 0);
                        end;
                        "First Name" := '';
                        "Middle Name" := '';
                        Surname := '';
                        "Job Title" := '';
                        "Company No." := "No.";
                        "Company Name" := Name;
                        "Salutation Code" := RMSetup."Def. Company Salutation Code";
                    end;
                Type::Person:
                    begin
                        CampaignTargetGrMgt.DeleteContfromTargetGr(InteractLogEntry);
                        Cont.Reset();
                        Cont.SetCurrentKey("Company No.");
                        Cont.SetRange("Company No.", "No.");
                        Cont.SetRange(Type, Type::Person);
                        // OnTypeChangeOnAfterContSetFilters(Cont, Rec);
                        // if Cont.FindFirst() then
                        //  Error(Text007, FieldCaption(Type));
                        if Type <> xContact.Type then begin
                            CalcFields("No. of Business Relations", "No. of Industry Groups");
                            TestField("No. of Business Relations", 0);
                            TestField("No. of Industry Groups", 0);
                            TestField("Currency Code", '');
                            TestField("VAT Registration No.", '');
                            // OnTypeChangeOnAfterTypePersonTestFields(Rec);
                        end;
                        if "Company No." = "No." then begin
                            "Company No." := '';
                            "Company Name" := '';
                            "Salutation Code" := RMSetup."Default Person Salutation Code";
                            NameBreakdown(Contact);
                        end;
                    end;
            end;
            //  OnAfterSetTypeForContact(Rec, xRec);
            Validate("Lookup Contact No.");
            if Cont.Get("No.") then begin
                if Type = Type::Company then
                    CheckDuplicates2(Contact, RMSetup)
                else
                    DuplMgt.RemoveContIndex(Contact, false);
            end;
        end
    end;

    local procedure CheckDuplicates2(var ContactRec: Record Contact; RMSetup: Record "Marketing Setup")
    var
        DuplMgt: Codeunit DuplicateManagement;
    begin
        //OnBeforeCheckDuplicates(Rec, IsHandled);
        // if IsHandled then
        // exit;
        if RMSetup."Maintain Dupl. Search Strings" then
            DuplMgt.MakeContIndex(ContactRec);
        if not GuiAllowed then
            exit;
        //   IsHandled := false;
        // OnBeforeLaunchDuplicateForm(ContactRec, IsHandled);
        //  if not IsHandled then
        if DuplMgt.DuplicateExist(ContactRec) then begin
            ContactRec.Modify;
            Commit();
            DuplMgt.LaunchDuplicateForm(ContactRec);
        end;
    end;

    local procedure NameBreakdown(var ContactRec: Record Contact)
    var
        NamePart: array[30] of Text[100];
        TempName: Text[250];
        FirstName250: Text[250];
        i: Integer;
        NoOfParts: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        // OnBeforeNameBreakdown(Rec, IsHandled);
        if IsHandled then
            exit;
        with ContactRec do begin
            if Type = Type::Company then
                exit;
            TempName := Name;
            while StrPos(TempName, ' ') > 0 do begin
                if StrPos(TempName, ' ') > 1 then begin
                    i := i + 1;
                    NamePart[i] := CopyStr(TempName, 1, StrPos(TempName, ' ') - 1);
                end;
                TempName := CopyStr(TempName, StrPos(TempName, ' ') + 1);
            end;
            i := i + 1;
            NamePart[i] := CopyStr(TempName, 1, MaxStrLen(NamePart[i]));
            NoOfParts := i;
            "First Name" := '';
            "Middle Name" := '';
            Surname := '';
            for i := 1 to NoOfParts do
                if (i = NoOfParts) and (NoOfParts > 1) then
                    Surname := CopyStr(NamePart[i], 1, MaxStrLen(Surname))
                else
                    if (i = NoOfParts - 1) and (NoOfParts > 2) then
                    "Middle Name" := CopyStr(NamePart[i], 1, MaxStrLen("Middle Name"))
                    else begin
                        FirstName250 := DelChr("First Name" + ' ' + NamePart[i], '<', ' ');
                        "First Name" := CopyStr(FirstName250, 1, MaxStrLen("First Name"));
                    end;
        end;
    end;

    var
        PreviewMode: Boolean;
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        Text005: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        JobsSetup: Record "Jobs Setup";
}
