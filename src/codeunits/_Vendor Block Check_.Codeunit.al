codeunit 60111 "Vendor Block Check"
{
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeValidateEvent', 'Blocked', false, false)]
    local procedure CheckOpenTransactionsOnBlock(var Rec: Record Vendor; var xRec: Record Vendor; CurrFieldNo: Integer)
    begin
        if Rec.Blocked = Rec.Blocked::" " then exit;
        CheckPurchaseHeaders(Rec."No.");
        CheckPurchaseLines(Rec."No.");
        CheckGenJournalLines(Rec."No.");
        CheckRequisitionLines(Rec."No.");
        CheckBankRecLines(Rec."No.");
        CheckProjectPlanningLines(Rec."No.");
    end;
    procedure CheckPurchaseHeaders(VendorNo: Code[20])
    var
        PurchHeader: Record "Purchase Header";
    begin
        // Buy-from Vendor
        PurchHeader.reset();
        PurchHeader.SetRange("Buy-from Vendor No.", VendorNo);
        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
        if PurchHeader.FindFirst()then ThrowError(VendorNo, StrSubstNo('Purchase %1 %2', PurchHeader."Document Type", PurchHeader."No."));
        // Pay-to Vendor
        PurchHeader.Reset();
        PurchHeader.SetRange("Pay-to Vendor No.", VendorNo);
        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
        if PurchHeader.FindFirst()then ThrowError(VendorNo, StrSubstNo('Purchase %1 %2', PurchHeader."Document Type", PurchHeader."No."));
    end;
    procedure CheckPurchaseLines(VendorNo: Code[20])
    var
        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Buy-from Vendor No.", VendorNo);
        if PurchLine.FindFirst()then begin
            if PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.")then begin
                if PurchHeader.Status = PurchHeader.Status::Open then ThrowError(VendorNo, StrSubstNo('Purchase %1 %2, line %3', PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No."));
            end;
        end;
    end;
    procedure CheckGenJournalLines(VendorNo: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        // Account Type = Vendor
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.SetRange("Account No.", VendorNo);
        if GenJnlLine.FindFirst()then ThrowError(VendorNo, StrSubstNo('Journal %1 / %2', GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name"));
        // Bal. Account Type = Vendor
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Bal. Account Type", GenJnlLine."Bal. Account Type"::Vendor);
        GenJnlLine.SetRange("Bal. Account No.", VendorNo);
        if GenJnlLine.FindFirst()then ThrowError(VendorNo, StrSubstNo('Journal %1 / %2', GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name"));
    end;
    procedure CheckRequisitionLines(VendorNo: Code[20])
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.Reset();
        ReqLine.SetRange("Vendor No.", VendorNo);
        if ReqLine.FindFirst()then ThrowError(VendorNo, StrSubstNo('Worksheet %1 / %2', ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name"));
    end;
    procedure CheckBankRecLines(VendorNo: Code[20])
    var
        BankRecLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankRecLine.Reset();
        BankRecLine.SetRange("Account Type", BankRecLine."Account Type"::Vendor);
        BankRecLine.SetRange("Account No.", VendorNo);
        if BankRecLine.FindFirst()then ThrowError(VendorNo, StrSubstNo('Bank reconciliation / payment reconciliation %1', BankRecLine."Statement No."));
    end;
    procedure CheckProjectPlanningLines(VendorNo: Code[20])
    var
        JobPlanningLine: Record "Job Planning Line";
        Job: Record Job;
    begin
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("GSSSupply From", VendorNo);
        if JobPlanningLine.FindSet()then repeat if Job.Get(JobPlanningLine."Job No.")then begin
                    if Job.GSSStatus = Job.GSSStatus::Open then ThrowError(VendorNo, StrSubstNo('Project %1, task %2, planning line %3', JobPlanningLine."Job No.", JobPlanningLine."Job Task No.", JobPlanningLine."Line No."));
                end;
            until JobPlanningLine.Next() = 0;
    end;
    procedure ThrowError(VendorNo: Code[20]; Source: Text)
    begin
        Error(BlockErr, VendorNo, Source);
    end;
    var BlockErr: Label 'Vendor %1 cannot be blocked because it is used in: %2.', Comment = '%1 = Vendor No., %2 = Where it is used';
}
