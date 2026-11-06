#pragma implicitwith disable
pageextension 60114 "GSSJob Card" extends "Job Card"
{
    PromotedActionCategories = 'New,Process,Report,Prices & Discounts,WIP,Navigate,Job,Print/Send,Release,Approve';

    layout
    {
        addlast(General)
        {
            field("Opportunity ID"; Rec."Opportunity ID")
            {
                ApplicationArea = All;
            }
            field("GSSExternal Document No."; Rec."GSSExternal Document No.")
            {
                ApplicationArea = All;
                Enabled = false;
                Visible = false;
            }
            field("GSSPurchaseOrderAmount"; Rec."GSSCustomer PO Amount")
            {
                ApplicationArea = All;
            }

            field("GSSPurchase Order No."; Rec."GSSPurchase Order No.")
            {
                ShowMandatory = true;
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            field("GSSTotal Budgeted Cost"; Rec."GSSTotal Budgeted Cost")
            {
                ApplicationArea = All;
            }
            field("GSSTotal Budgeted Price"; Rec."GSSTotal Budgeted Price")
            {
                ApplicationArea = All;
            }
            field("GSSTotal Billable Price"; Rec."GSSTotal Billable Price")
            {
                ApplicationArea = All;
            }
            field("GSSGross Margin "; Rec."GSSGross Margin")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("GSSGross Margin %"; Rec."GSSGross Margin %")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Customer PO Received"; Rec."Customer PO Received")
            {
                ApplicationArea = All;
            }
            field(GSSStatus; Rec.GSSStatus)
            {
                ApplicationArea = All;
            }
            ////Rk
            // field(needExceptionApproval; Rec."Need Exception Approval")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }

            field("Delivery Exception allowed"; Rec."Delivery Exception allowed")
            {
                ApplicationArea = All;
                Editable = DeliveryExceptionEditable;
            }
            field("Delivery Exc. allowed by User"; Rec."Delivery Exc. allowed by User")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Invoice Exception allowed"; Rec."Invoice Exception allowed")
            {
                ApplicationArea = All;
                Editable = DeliveryExceptionEditable;
            }
            field("Invoice Exc. allowed by User"; Rec."Invoice Exc. allowed by User")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Need Finance Approval"; Rec."Need Finance Approval")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Customer Credit Limit"; Rec."Customer Credit Limit")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            field("Customer Balance(LCY)"; BalLCY)
            {
                ApplicationArea = All;
                Editable = false;
                trigger OnDrillDown()
                var
                    CusLedEntries: Page "Customer Ledger Entries";
                    CLERec: Record "Cust. Ledger Entry";
                begin
                    CLERec.Reset();
                    CLERec.SetRange("Customer No.", Rec."Sell-to Customer No.");
                    CLERec.SetRange(Open, true);
                    CusLedEntries.SetTableView(CLERec);
                    CusLedEntries.Run();
                end;
            }
            field("Customer Balance Due(LCY)"; BalDueLCY)
            {
                ApplicationArea = All;
                Editable = false;
                trigger OnDrillDown()
                var
                    CusLedEntries: Page "Customer Ledger Entries";
                    CLERec: Record "Cust. Ledger Entry";
                begin
                    CLERec.Reset();
                    CLERec.SetRange("Customer No.", Rec."Sell-to Customer No.");
                    CLERec.SetRange(Open, true);
                    CLERec.SetFilter("Due Date", '..%1', Today);
                    CusLedEntries.SetTableView(CLERec);
                    CusLedEntries.Run();
                end;
            }
            field(Cust_CreditLimitLCY; Rec.Cust_CreditLimitLCY)
            {
                ApplicationArea = All;
            }
            field(Cust_CreditInsuranceLimitLCY; Rec.Cust_CreditInsuranceLimitLCY)
            {
                ApplicationArea = All;
            }
            field("Sales Value"; Rec."Sales Value")
            {
                Caption = 'Order Value';
                ApplicationArea = All;
                Editable = false;
            }
            field("Invoice Value"; Rec."Invoice Value")
            {
                Caption = 'Invoice Value';
                ApplicationArea = All;
                Editable = false;
            }
            field("Shipment Value"; Rec."Shipment Value")
            {
                Caption = 'Shipment Value';
                ApplicationArea = All;
                Editable = false;
            }
            field("Sales Quote No."; Rec."Sales Quote No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Person Responsible")
        {
            field("GSSSalesperson Code"; Rec."GSSSalesperson Code")
            {
                ApplicationArea = All;
                ShowMandatory = IsSalesPersonMandatory;
            }
            field(GSSTeam; Rec.GSSTeam)
            {
                ApplicationArea = All;
                ShowMandatory = IsSalesPersonMandatory;
            }
        }
        modify("Project Manager")
        {
            ShowMandatory = true;
        }
        modify("Person Responsible")
        {
            ShowMandatory = true;
        }
        modify("Invoice Currency Code")
        {
            ShowMandatory = true;
        }
        modify("WIP Posting Method")
        {
            Editable = false;
        }
        movebefore(GSSPurchaseOrderAmount; "External Document No.")

        addafter("Sales Quote No.")
        {
            // field("Available Credit Amount"; Rec."Available Credit Amount")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
            field("Credit Exposure"; Rec."Credit Exposure")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        //Calculate WIP
        modify("<Action82>")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("WIP Method");
                Rec.TestStatusReleased();
            end;
        }
        //Post WIP to GL
        modify("<Action83>")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestStatusReleased();
            end;
        }

        addafter("&Job")
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;

                action(CalculateGrossMargin)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Calculate Gross Margin';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        JobDocumentClass: Codeunit "GSSJob Document Class";
                    begin
                        JobDocumentClass.UpdateGrossMarginForJob(Rec);
                        CurrPage.Update();
                    end;
                }

                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        GSSApprovalsMgmt: Codeunit GSSApprovalMgt;
                        JobDocumentClass: Codeunit "GSSJob Document Class";
                        JobTaskLineRec: Record "Job Task";
                    //  "Delivery Exc. Mgt.": codeunit GSSExceptionApprovalMgt;
                    begin
                        // Rec.SecurityFiltering := Rec.SecurityFiltering::Filtered;
                        //Update Wip Total
                        Rec.TestField("Opportunity ID");
                        if Rec.GSSStatus = Rec.GSSStatus::Cancelled then
                            Error('This Order is Cancelled');
                        JobTaskLineRec.SetRange("Job No.", Rec."No.");
                        if JobTaskLineRec.FindSet() then
                            repeat
                                JobTaskLineRec.Validate("WIP-Total", JobTaskLineRec."WIP-Total"::Total);
                                JobTaskLineRec.Modify();
                            until JobTaskLineRec.Next() = 0;
                        //Update Wip Total
                        JobDocumentClass.UpdateGrossMarginForJob(Rec);
                        CurrPage.Update();
                        if Rec.GSSStatus = Rec.GSSStatus::Open then
                            if GSSApprovalsMgmt.CheckJobApprovalPossible(Rec) then
                                GSSApprovalsMgmt.OnSendJobDocumentForApproval(Rec);
                        // if Rec.GSSStatus = Rec.GSSStatus::Released then
                        //     if "Delivery Exc. Mgt.".IsExceptionApprovalWorkflowEnabled(Rec) then
                        //         "Delivery Exc. Mgt.".OnSendExceptionForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category10;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit GSSApprovalMgt;
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    // "Delivery Exc. Mgt.": codeunit GSSExceptionApprovalMgt;

                    begin
                        ApprovalsMgmt.OnCancelJobApprovalRequest(Rec);

                        // ///Rk 
                        // "Delivery Exc. Mgt.".OnCancelExceptionApprovalRequest(Rec);
                        // WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                    end;
                }
                action(ApprovalEntries)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        commit;
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
            group(Action21)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        JobDocumentClass: Codeunit "GSSJob Document Class";
                    begin
                        JobDocumentClass.PerformManualRelease(Rec);
                    end;
                }
                action(Cancel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel';
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        JobDocumentClass: Codeunit "GSSJob Document Class";
                        UserSetupRec: Record "User Setup";
                        CommentLine: Record "Comment Line";
                        XMLParameters: Text;
                        XMLBufferWriter: Codeunit "XML Buffer Writer";
                        XMLBuffer: Record "XML Buffer";
                        XMLSpecialInterestNode: Record "XML Buffer";
                        ItemVendor: Record "Item Vendor";
                        Comments: Text[80];
                        i: Integer;
                        paramNo: Integer;
                        bool: Boolean;
                        CreatePurchaseOrder: Report "Update Job Comments";
                        NewCommentLine: Record "Comment Line";
                        PurHdr: Record "Purchase Header";
                        SalInvLine: Record "Sales Invoice Line";
                        JPLRec: Record "Job Planning Line";
                    begin
                        JPLRec.SetRange("Job No.", REc."No.");
                        if JPLRec.FindFirst() then
                            Error('Planning lines exist for this job');
                        Rec.TestField(Status, Rec.Status::Open);
                        if Rec.GSSStatus = Rec.GSSStatus::Open then begin
                            Clear(Comments);
                            i := 1;
                            paramNo := 1;
                            // CreatePurchaseOrder.SetVendors(VendorNoFilter, true, true, true, true, true);
                            XMLParameters := CreatePurchaseOrder.RunRequestPage();
                            if XMLParameters <> '' then begin
                                XMLBufferWriter.InitializeXMLBufferFromText(XMLBuffer, XMLParameters);
                                XMLBuffer.SetFilter(Path, '/ReportParameters/Options/Field/@name');
                                if XMLBuffer.FindSet then
                                    repeat
                                        if XMLSpecialInterestNode.Get(XMLBuffer."Parent Entry No.") then begin
                                            if paramNo = 1 then begin
                                                Comments := XMLSpecialInterestNode.Value;
                                                paramNo += 1;
                                            end
                                        end;
                                    until XMLBuffer.Next() = 0;
                            end;
                            XMLBuffer.DeleteAll();
                            if Comments = '' then
                                Error('Please enter the comments');
                            CommentLine.Reset();
                            CommentLine.SetRange("No.", Rec."No.");
                            CommentLine.SetRange("Table Name", CommentLine."Table Name"::Job);
                            if CommentLine.FindLast() then begin
                                NewCommentLine.Init();
                                NewCommentLine.Validate("Table Name", NewCommentLine."Table Name"::Job);
                                NewCommentLine.Validate("No.", Rec."No.");
                                NewCommentLine.Validate("Line No.", CommentLine."Line No." + 10000);
                                NewCommentLine.Validate(Date, WorkDate);
                                NewCommentLine.Validate(Comment, Comments);
                                NewCommentLine.Insert();
                            end else begin
                                NewCommentLine.Init();
                                NewCommentLine.Validate("Table Name", NewCommentLine."Table Name"::Job);
                                NewCommentLine.Validate("No.", Rec."No.");
                                NewCommentLine.Validate("Line No.", 10000);
                                NewCommentLine.Validate(Date, WorkDate);
                                NewCommentLine.Validate(Comment, Comments);
                                NewCommentLine.Insert();
                            end;
                            //Updating Job-Comment --end
                            if ((Rec.PercentCompleted() <> 0) or (Rec.PercentInvoiced() <> 0)) then
                                Error('You cannot cancel this order');
                            PurHdr.Reset();
                            PurHdr.SetRange("GSSJob No.", Rec."No.");
                            if PurHdr.FindFirst() then
                                Error('You cannot cancel this order');
                            SalInvLine.Reset();
                            SalInvLine.SetRange("Job No.", Rec."No.");
                            if SalInvLine.FindFirst() then
                                Error('You cannot cancel this order');
                            if UserSetupRec.Get(UserId) then
                                if UserSetupRec."Allow Reopening" then begin
                                    Rec.Validate(GSSStatus, Rec.GSSStatus::Cancelled);
                                    Rec.Modify();
                                end else
                                    Error('You are not allowed to cancel the document');
                        end else begin
                            Error('Please Reopen the Document to Cancel the Order');
                        end;
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = Rec.GSSStatus <> Rec.GSSStatus::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        JobDocumentClass: Codeunit "GSSJob Document Class";
                        UserSetupRec: Record "User Setup";
                        CommentLine: Record "Comment Line";
                        XMLParameters: Text;
                        XMLBufferWriter: Codeunit "XML Buffer Writer";
                        XMLBuffer: Record "XML Buffer";
                        XMLSpecialInterestNode: Record "XML Buffer";
                        ItemVendor: Record "Item Vendor";
                        Comments: Text[80];
                        i: Integer;
                        paramNo: Integer;
                        bool: Boolean;
                        CreatePurchaseOrder: Report "Update Job Comments";
                        NewCommentLine: Record "Comment Line";
                    begin
                        commit;
                        //Updating Job-Comment --start
                        if Rec.GSSStatus = Rec.GSSStatus::Cancelled then //KK
                            Error('You cannot open the cancelled Document'); //KK
                        Clear(Comments);
                        i := 1;
                        paramNo := 1;
                        // CreatePurchaseOrder.SetVendors(VendorNoFilter, true, true, true, true, true);
                        XMLParameters := CreatePurchaseOrder.RunRequestPage();
                        if XMLParameters <> '' then begin
                            XMLBufferWriter.InitializeXMLBufferFromText(XMLBuffer, XMLParameters);
                            XMLBuffer.SetFilter(Path, '/ReportParameters/Options/Field/@name');
                            if XMLBuffer.FindSet then
                                repeat
                                    if XMLSpecialInterestNode.Get(XMLBuffer."Parent Entry No.") then begin
                                        if paramNo = 1 then begin
                                            Comments := XMLSpecialInterestNode.Value;
                                            paramNo += 1;
                                        end
                                    end;
                                until XMLBuffer.Next() = 0;
                        end;
                        XMLBuffer.DeleteAll();
                        if Comments = '' then
                            Error('Please enter the comments');
                        CommentLine.Reset();
                        CommentLine.SetRange("No.", Rec."No.");
                        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Job);
                        if CommentLine.FindLast() then begin
                            NewCommentLine.Init();
                            NewCommentLine.Validate("Table Name", NewCommentLine."Table Name"::Job);
                            NewCommentLine.Validate("No.", Rec."No.");
                            NewCommentLine.Validate("Line No.", CommentLine."Line No." + 10000);
                            NewCommentLine.Validate(Date, WorkDate);
                            NewCommentLine.Validate(Comment, Comments);
                            NewCommentLine.Insert();
                        end else begin
                            NewCommentLine.Init();
                            NewCommentLine.Validate("Table Name", NewCommentLine."Table Name"::Job);
                            NewCommentLine.Validate("No.", Rec."No.");
                            NewCommentLine.Validate("Line No.", 10000);
                            NewCommentLine.Validate(Date, WorkDate);
                            NewCommentLine.Validate(Comment, Comments);
                            NewCommentLine.Insert();
                        end;
                        //Updating Job-Comment --end

                        if UserSetupRec.Get(UserId) then
                            if UserSetupRec."Allow Reopening" then begin
                                JobDocumentClass.PerformManualReopen(Rec)
                            end else
                                Error('You are not allowed to reopen the document');
                        if rec.GSSStatus = Rec.GSSStatus::Open then begin
                            Rec."Need Exception Approval" := false;
                            Rec.Modify();
                        end;
                    end;
                }
            }
        }
        addlast(reporting)
        {
            action(GSSProformaInvoice)
            {
                Caption = 'Proforma Invoice';
                Image = Report2;
                ApplicationArea = ALL;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    PI: Report GSSProformaInvoice;
                    JOB: Record "Job";
                begin
                    CurrPage.SetSelectionFilter(JOB);
                    PI.SetTableView(Job);
                    PI.RunModal();
                end;

            }
        }
        //Rk281026
        modify(SalesInvoicesCreditMemos)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Commit();
            end;
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        User: Record User;
    begin
        if User.Get() then;
        if UserSetup.Get(UserId) then begin
            if UserSetup."Block Delivery Access" then
                DeliveryExceptionEditable := true
            else
                DeliveryExceptionEditable := false;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        SetControlVisibility();
    end;

    trigger OnAfterGetRecord()
    var
        DetCustLedEntries: Record "Detailed Cust. Ledg. Entry";
        DetCustLedEntries2: Record "Detailed Cust. Ledg. Entry";
    begin
        SetControlVisibility();
        Clear(BalLCY);
        Clear(BalDueLCY);
        DetCustLedEntries.Reset();
        DetCustLedEntries.SetRange("Customer No.", Rec."Sell-to Customer No.");
        if DetCustLedEntries.FindSet() then begin
            DetCustLedEntries.CalcSums("Amount (LCY)");
            BalLCY := DetCustLedEntries."Amount (LCY)";
        end;

        DetCustLedEntries2.Reset();
        DetCustLedEntries2.SetRange("Customer No.", Rec."Sell-to Customer No.");
        DetCustLedEntries2.SetFilter("Initial Entry Due Date", '..%1', Today);
        if DetCustLedEntries2.FindSet() then begin
            DetCustLedEntries2.CalcSums("Amount (LCY)");
            BalDueLCY := DetCustLedEntries2."Amount (LCY)";
        end;


        ///Rk
        CalculateCreditExposure();
        // CalcCreditExposure();
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        JobSetup: Record "Jobs Setup";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);

        IsSalesPersonMandatory := false;
        if JobSetup.Get() then
            IsSalesPersonMandatory := JobSetup."GSSSalesperson Code Mandatory";
    end;




    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        CanRequestApprovalForFlow: Boolean;
        IsSaas: Boolean;
        IsSalesPersonMandatory: Boolean;
        DeliveryExceptionEditable: Boolean;
        CustBal: Decimal;
        BalLCY: Decimal;
        BalDueLCY: Decimal;



    procedure CalculateCreditExposure()
    var
        SalesLine: Record "Sales Line";
        salesHeader: Record "Sales Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        OpenSOAmount: Decimal;
        OpenCLEAmount: Decimal;
        Job: Record Job;
        TotalSoAmount: Decimal;
        JobTask: Record "Job Task";

    begin
        if Rec."Sell-to Customer No." = '' then
            exit;

        OpenSOAmount := 0;
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        if SalesHeader.FindSet() then
            repeat
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
                if SalesLine.FindSet() then
                    repeat
                        // SalesLine.CalcFields("Outstanding Amount");
                        OpenSOAmount += SalesLine."Outstanding Amount";
                    until SalesLine.Next() = 0;
            until SalesHeader.Next() = 0;

        Job.Reset();
        Job.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
        if Job.FindSet() then
            repeat
                if (Round(Job.PercentCompleted(), 0.01) >= 100) and
                   (Round(Job.PercentInvoiced(), 0.01) >= 100)
                then begin
                    JobTask.SetRange("Job No.", Job."No.");
                    JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
                    if JobTask.FindSet() then
                        repeat
                            JobTask.CalcFields("Contract (Total Price)");
                            TotalSoAmount += JobTask."Contract (Total Price)";
                        until JobTask.Next() = 0;
                end;
            until Job.Next() = 0;



        OpenCLEAmount := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey("Customer No.", Open);
        CustLedgerEntry.SetRange("Customer No.", Rec."Sell-to Customer No.");
        CustLedgerEntry.SetRange(Open, true);
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry.CalcFields("Remaining Amount");
                OpenCLEAmount += CustLedgerEntry."Remaining Amount";
            until CustLedgerEntry.Next() = 0;

        // 3. Update fields


        Rec."Available Credit Amount" := Rec."Customer Credit Limit" - TotalSoAmount - OpenCLEAmount;

        Rec.Modify(true);
    end;

    local procedure CalcCreditExposure()
    var
        myInt: Integer;
        customer: Record Customer;
        TotalUtilizedtotaloutstandingInvoiced: Decimal;
        TotalPendingInvoice: Decimal;
    begin
        Clear(TotalUtilizedtotaloutstandingInvoiced);
        Clear(TotalPendingInvoice);
        customer.Reset();
        customer.SetRange("No.", Rec."Sell-to Customer No.");
        if customer.FindFirst() then begin
            customer.CalcFields("Balance (LCY)");
            TotalUtilizedtotaloutstandingInvoiced := customer."Balance (LCY)";
        end;
        TotalPendingInvoice := Rec."Sales Value" - Rec.Cust_BalanceLCY;
        Rec."Credit Exposure" := Rec.Cust_CreditLimitLCY - TotalUtilizedtotaloutstandingInvoiced - TotalPendingInvoice;
        Rec.Modify();
    end;
}

