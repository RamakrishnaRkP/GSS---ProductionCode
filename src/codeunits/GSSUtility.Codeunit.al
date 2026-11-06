codeunit 60103 GSSUtility
{
    trigger OnRun()
    begin
        Message('Test');
    end;
    var Text026: Label 'ZERO';
    Text027: Label 'HUNDRED';
    Text028: Label 'AND';
    Text029: Label '%1 results in a written number that is too long.';
    Text030: Label ' is already applied to %1 %2 for customer %3.';
    Text031: Label ' is already applied to %1 %2 for vendor %3.';
    Text032: Label 'ONE';
    Text033: Label 'TWO';
    Text034: Label 'THREE';
    Text035: Label 'FOUR';
    Text036: Label 'FIVE';
    Text037: Label 'SIX';
    Text038: Label 'SEVEN';
    Text039: Label 'EIGHT';
    Text040: Label 'NINE';
    Text041: Label 'TEN';
    Text042: Label 'ELEVEN';
    Text043: Label 'TWELVE';
    Text044: Label 'THIRTEEN';
    Text045: Label 'FOURTEEN';
    Text046: Label 'FIFTEEN';
    Text047: Label 'SIXTEEN';
    Text048: Label 'SEVENTEEN';
    Text049: Label 'EIGHTEEN';
    Text050: Label 'NINETEEN';
    Text051: Label 'TWENTY';
    Text052: Label 'THIRTY';
    Text053: Label 'FORTY';
    Text054: Label 'FIFTY';
    Text055: Label 'SIXTY';
    Text056: Label 'SEVENTY';
    Text057: Label 'EIGHTY';
    Text058: Label 'NINETY';
    Text059: Label 'THOUSAND';
    Text060: Label 'MILLION';
    Text061: Label 'BILLION';
    Text16526: Label 'ZERO';
    Text50001: Label 'Do you want to Create Invoices?';
    Text001: Label 'Sales Quote Lines retreived.';
    Text002: Label 'Sales Quote No.: %1';
    Text003: Label 'Sales Quote No. %1 is already retrieved in this Document.';
    Text004: Label 'Cost updated for Sales Quote linked to this Purchase Quote.';
    Text005: Label 'No Sales Quote lines found to update.';
    Text006: Label 'Do you want to update the cost in Sales Quote?';
    Text007: Label 'Cost is already updated for Sales Quote %1 Line No. %2 (Item No. %3) from Purchase Quote %4. Do you want to Override and continue for all lines?';
    Text008: Label 'Aborted by User.';
    GLSetup: Record "General Ledger Setup";
    OnesText: array[20]of Text;
    TensText: array[10]of Text;
    ExponentText: array[5]of Text;
    DecText: Text;
    Text50051: Label 'Do you want to Delink Drop Shipment for Purchase Document %1.';
    Text50052: Label 'Drop Shipment for Purchase Document %1 delinked.';
    Text50053: Label 'Drop Shipment already exists for Purchase Document Line %1 %2.';
    Text50054: Label 'Do you want to link Drop Shipment for Purchase Line %1 %2 with current line.';
    procedure GetSalesQuoteLines(PurchHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    var
        PurchLines: Record "Purchase Line";
        SalesLines: Record "Sales Line";
        LineNo: Integer;
    begin
        Clear(PurchLines);
        PurchLines.Reset;
        PurchLines.SetRange("Document Type", PurchHeader."Document Type");
        PurchLines.SetRange("Document No.", PurchHeader."No.");
        if PurchLines.FindLast then LineNo:=PurchLines."Line No.";
        Clear(PurchLines);
        PurchLines.Reset;
        PurchLines.SetRange("Document Type", PurchHeader."Document Type");
        PurchLines.SetRange("Document No.", PurchHeader."No.");
        //CONV-MISSING -
        //PurchLines.SETRANGE("Sales Quote No.",SalesHeader."No.");
        //CONV-MISSING +
        if PurchLines.FindFirst then begin
            Error(StrSubstNo(Text003, SalesHeader."No."));
        end;
        Clear(SalesLines);
        SalesLines.Reset;
        SalesLines.SetRange("Document Type", SalesHeader."Document Type");
        SalesLines.SetRange("Document No.", SalesHeader."No.");
        //SalesLines.SETRANGE(Type,SalesLines.Type::Item);
        if SalesLines.FindFirst then begin
            Clear(PurchLines);
            PurchLines.Init;
            PurchLines."Document Type":=PurchHeader."Document Type";
            PurchLines."Document No.":=PurchHeader."No.";
            LineNo+=10000;
            PurchLines."Line No.":=LineNo;
            PurchLines.Type:=PurchLines.Type::" ";
            PurchLines.Description:=StrSubstNo(Text002, SalesLines."Document No.");
            PurchLines.Insert(true);
            repeat Clear(PurchLines);
                PurchLines.Init;
                PurchLines."Document Type":=PurchHeader."Document Type";
                PurchLines."Document No.":=PurchHeader."No.";
                LineNo+=10000;
                PurchLines."Line No.":=LineNo;
                PurchLines.Insert(true);
                PurchLines.Validate(Type, SalesLines.Type);
                PurchLines.Validate("No.", SalesLines."No.");
                PurchLines.Validate("Unit of Measure Code", SalesLines."Unit of Measure Code");
                PurchLines.Validate(Quantity, SalesLines.Quantity);
                //CONV-MISSING -
                //PurchLines."Sales Quote No." := SalesLines."Document No.";
                //PurchLines."Sales Quote Line No." := SalesLines."Line No.";
                //CONV-MISSING +
                PurchLines.Modify;
            until SalesLines.Next = 0;
        end;
        Message(Text001);
    end;
    procedure DectoStr(Amt: Decimal): Text var
        AmtText: Text;
        DecText: Text;
    begin
        AmtText:=(Format(Amt, 0, '<Integer Thousand><Decimals>'));
        if StrPos(AmtText, '.') = 0 then begin
            AmtText:=AmtText + '.00';
        end
        else
        begin
            DecText:=(CopyStr(AmtText, StrPos(AmtText, '.') + 1, StrLen(AmtText)));
            if StrLen(DecText) = 1 then AmtText:=AmtText + '0';
        end;
        exit(AmtText);
    end;
    procedure FormatNoText(var NoText: array[2]of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
        OnesDec: Integer;
        TensDec: Integer;
        CurrRecord: Record Currency;
    begin
        InitTextVariable;
        Clear(NoText);
        NoTextIndex:=1;
        NoText[1]:='';
        GLSetup.Get;
        if No < 1 then AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else
            for Exponent:=4 downto 1 do begin
                PrintExponent:=false;
                Ones:=No div Power(1000, Exponent - 1);
                Hundreds:=Ones div 100;
                Tens:=(Ones mod 100) div 10;
                Ones:=Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end
                else if(Tens * 10 + Ones) > 0 then AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1)then AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No:=No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        // AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        // DecimalPosition := GetAmtDecimalPosition(CurrencyCode);
        // DecText := FormatDecText(No * DecimalPosition);
        // //AddToNoText(NoText,NoTextIndex,PrintExponent,(FORMAT(No * DecimalPosition) + '/' + FORMAT(DecimalPosition))); //CP
        // AddToNoText(NoText, NoTextIndex, PrintExponent, (DecText)); //CP
        if CurrencyCode <> '' then begin
            CurrRecord.Get(CurrencyCode);
            if CurrRecord."Amount Rounding Precision" <> 0 then DecimalPosition:=1 / CurrRecord."Amount Rounding Precision"
            else
                DecimalPosition:=1;
        end
        else if GLSetup."Amount Rounding Precision" <> 0 then DecimalPosition:=1 / GLSetup."Amount Rounding Precision"
            else
                DecimalPosition:=1;
        if No <> 0 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
            AddToNoText(NoText, NoTextIndex, PrintExponent, (Format(No * DecimalPosition) + '/' + Format(DecimalPosition)));
        end;
        if CurrencyCode <> '' then AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;
    local procedure AddToNoText(var NoText: array[2]of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent:=true;
        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1])do begin
            NoTextIndex:=NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText)then Error(Text029, AddText);
        end;
        NoText[NoTextIndex]:=DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;
    procedure InitTextVariable()
    begin
        OnesText[1]:=Text032;
        OnesText[2]:=Text033;
        OnesText[3]:=Text034;
        OnesText[4]:=Text035;
        OnesText[5]:=Text036;
        OnesText[6]:=Text037;
        OnesText[7]:=Text038;
        OnesText[8]:=Text039;
        OnesText[9]:=Text040;
        OnesText[10]:=Text041;
        OnesText[11]:=Text042;
        OnesText[12]:=Text043;
        OnesText[13]:=Text044;
        OnesText[14]:=Text045;
        OnesText[15]:=Text046;
        OnesText[16]:=Text047;
        OnesText[17]:=Text048;
        OnesText[18]:=Text049;
        OnesText[19]:=Text050;
        TensText[1]:='';
        TensText[2]:=Text051;
        TensText[3]:=Text052;
        TensText[4]:=Text053;
        TensText[5]:=Text054;
        TensText[6]:=Text055;
        TensText[7]:=Text056;
        TensText[8]:=Text057;
        TensText[9]:=Text058;
        ExponentText[1]:='';
        ExponentText[2]:=Text059;
        ExponentText[3]:=Text060;
        ExponentText[4]:=Text061;
    end;
    local procedure GetAmtDecimalPosition(CurrCode: Code[10]): Decimal var
        Currency: Record Currency;
    begin
        if CurrCode = '' then Currency.InitRoundingPrecision
        else
        begin
            Currency.Get(CurrCode);
            Currency.TestField("Amount Rounding Precision");
        end;
        exit(1 / Currency."Amount Rounding Precision");
    end;
    local procedure FormatDecText(Fils: Decimal)FilsText: Text var
        FilsTens: Decimal;
        FilsOnes: Decimal;
        FilsHundred: Decimal;
    begin
        Clear(FilsText);
        //Fils := ROUND(Fils,1);
        if Fils = 0 then begin
            FilsText:='ZERO';
            exit;
        end;
        // if Fils > 99 then begin
        //     FilsText := StrSubstNo('%1', Fils);
        //     exit;
        // end;
        if Fils > 999 then Error('Baisa greater than 999 not allowed.');
        FilsHundred:=(Fils mod 1000) div 100;
        FilsTens:=(Fils mod 100) div 10;
        FilsOnes:=Fils mod 10;
        if FilsHundred >= 0 then begin
            FilsText:=FilsText + ' ' + OnesText[FilsHundred];
            FilsText:=StrSubstNo(FilsText + ' %1', Text027);
            if FilsTens >= 2 then begin
                FilsText:=TensText[FilsTens];
                if FilsOnes <> 0 then FilsText:=FilsText + ' ' + OnesText[FilsOnes];
            end
            else if FilsTens >= 1 then begin
                    FilsTens:=(Fils mod 100);
                    if FilsTens > 0 then FilsText:=FilsText + ' ' + OnesText[FilsTens];
                end
                else if FilsOnes >= 1 then begin
                        FilsText:=OnesText[FilsOnes]end;
        end
        else if FilsTens >= 2 then begin
                FilsText:=TensText[FilsTens];
                if FilsOnes <> 0 then FilsText:=FilsText + ' ' + OnesText[FilsOnes]end
            else
            begin
                FilsText:=OnesText[Fils]end;
    end;
    procedure GetEmployeeName(EmpCode: Code[20]): Text var
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    begin
        Clear(DimValue);
        GLSetup.Get;
        if DimValue.Get(GLSetup."Shortcut Dimension 8 Code", EmpCode)then;
        exit(DimValue.Name);
    end;
    // procedure SendMail(Email: Text; CC: Text; Subject: Text; Body: Text; AttachPath: Text)
    // var
    //     SMTPRec: Record "SMTP Mail Setup";
    //     SMTP: Codeunit "SMTP Mail";
    // begin
    //     SMTPRec.Get;
    //     SMTP.CreateMessage('Dynamics NAV', SMTPRec."User ID", Email, Subject, '', true);
    //     //CONV-MISSING -
    //     //TODO: Convert AddAttachmentStream instead of AddAttachment method as it is not supported in 
    //     // if AttachPath <> '' then
    //     //     SMTP.AddAttachment(AttachPath, 'Report.pdf');
    //     //CONV-MISSING +
    //     SMTP.AppendBody('Dear Sir/Madam,');
    //     SMTP.AppendBody('<br><br>');
    //     SMTP.AppendBody(Body);
    //     SMTP.AppendBody('</br></br>');
    //     SMTP.AppendBody('<br><br>');
    //     SMTP.AppendBody('Regards,');
    //     SMTP.AppendBody('</br></br>');
    //     SMTP.AppendBody('<br>');
    //     SMTP.AppendBody('NAV Administrator');
    //     SMTP.AppendBody('</br>');
    //     SMTP.AppendBody('<br>');
    //     SMTP.AppendBody('</br>');
    //     SMTP.AppendBody('<HR>');
    //     SMTP.AppendBody('This is a system generated mail. Please do not reply to this mail ID.');
    //     SMTP.Send;
    // end;
    local procedure GetNextInvoiceDate(InvDate: Date): Date begin
        if Date2DMY(InvDate, 2)in[9, 10, 11]then exit(DMY2Date(1, 12, Date2DMY(InvDate, 3)));
        if Date2DMY(InvDate, 2)in[12]then exit(DMY2Date(1, 3, Date2DMY(InvDate, 3) + 1));
        if Date2DMY(InvDate, 2)in[1, 2]then exit(DMY2Date(1, 3, Date2DMY(InvDate, 3)));
        if Date2DMY(InvDate, 2)in[3, 4, 5, 6, 7, 8]then exit(DMY2Date(1, 9, Date2DMY(InvDate, 3)));
    end;
    procedure GetApprovers(var UserSetup: array[8]of Record "User Setup"; var ApprovedDateTime: array[8]of DateTime; RecRef: RecordRef)
    var
        ApprovalEntry: Record "Approval Entry";
        i: Integer;
        UserSetup2: Record "User Setup";
    begin
        //Approvers
        i:=0;
        Clear(ApprovalEntry);
        ApprovalEntry.Reset;
        ApprovalEntry.SetRange("Record ID to Approve", RecRef.RecordId);
        ApprovalEntry.SetFilter(Status, '%1|%2|%3', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created, ApprovalEntry.Status::Approved);
        if ApprovalEntry.FindFirst then repeat i+=1;
                Clear(UserSetup2);
                if UserSetup2.Get(ApprovalEntry."Approver ID")then;
                UserSetup[i]:=UserSetup2;
                if ApprovalEntry.Status = ApprovalEntry.Status::Approved then ApprovedDateTime[i]:=ApprovalEntry."Last Date-Time Modified";
            until ApprovalEntry.Next = 0;
    end;
    procedure GetApproversPosted(var UserSetup: array[20]of Record "User Setup"; var ApprovedDateTime: array[8]of DateTime; DocNo: Code[20])
    var
        PostedApprovalEntry: Record "Posted Approval Entry";
        i: Integer;
        UserSetup2: Record "User Setup";
    begin
        //Approvers
        i:=0;
        Clear(PostedApprovalEntry);
        PostedApprovalEntry.Reset;
        PostedApprovalEntry.SetRange("Table ID", 17);
        PostedApprovalEntry.SetRange("Document No.", DocNo);
        PostedApprovalEntry.SetRange(Status, PostedApprovalEntry.Status::Approved);
        if PostedApprovalEntry.FindFirst then repeat i+=1;
                Clear(UserSetup2);
                if UserSetup2.Get(PostedApprovalEntry."Approver ID")then;
                UserSetup[i]:=UserSetup2;
                if PostedApprovalEntry.Status = PostedApprovalEntry.Status::Approved then ApprovedDateTime[i]:=PostedApprovalEntry."Last Date-Time Modified";
            until(PostedApprovalEntry.Next = 0) or (i = 8);
    end;
    procedure GetLotNo(SourceType: Integer; SourceSubType: Integer; SourceID: Code[20]; SourceRefNo: Integer)LotNo: Code[200]var
        ReservationEntry: Record "Reservation Entry";
    begin
        Clear(ReservationEntry);
        ReservationEntry.Reset;
        ReservationEntry.SetRange("Source Type", SourceType);
        ReservationEntry.SetRange("Source Subtype", SourceSubType);
        ReservationEntry.SetRange("Source ID", SourceID);
        ReservationEntry.SetRange("Source Ref. No.", SourceRefNo);
        if ReservationEntry.FindFirst then repeat if LotNo = '' then LotNo+=ReservationEntry."Lot No." + StrSubstNo('(%1)', Format(Abs(ReservationEntry.Quantity)))
                else
                    LotNo+=',' + ReservationEntry."Lot No." + StrSubstNo('(%1)', Format(Abs(ReservationEntry.Quantity)));
            until ReservationEntry.Next = 0;
        exit(LotNo);
    end;
    procedure DelinkDropShipment(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
    begin
        if not Confirm(StrSubstNo(Text50051, PurchHeader."No."), false)then exit;
        Clear(PurchLine);
        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        if PurchLine.FindFirst then repeat PurchLine.TestField("Quantity Received", 0);
                if PurchLine."Sales Order No." <> '' then begin
                    if SalesLine.Get(SalesLine."Document Type"::Order, PurchLine."Sales Order No.", PurchLine."Sales Order Line No.")then begin
                        SalesLine.TestField("Quantity Shipped", 0);
                        SalesLine."Purchase Order No.":='';
                        SalesLine."Purch. Order Line No.":=0;
                        SalesLine."Drop Shipment":=false;
                        SalesLine."Purchasing Code":='';
                        SalesLine.Modify(true);
                    end;
                    PurchLine."Sales Order No.":='';
                    PurchLine."Sales Order Line No.":=0;
                    PurchLine."Purchasing Code":='';
                    PurchLine."Drop Shipment":=false;
                    PurchLine.Modify(true);
                end;
            until PurchLine.Next = 0;
        Message(StrSubstNo(Text50052, PurchHeader."No."));
    end;
    procedure LinkDropShipment(SalesLine: Record "Sales Line")
    var
        PurchLine: Record "Purchase Line";
    begin
        if not SalesLine."Drop Shipment" then exit;
        if SalesLine."Purch. Order Line No." = 0 then exit;
        if not Confirm(StrSubstNo(Text50054, SalesLine."Purchase Order No.", SalesLine."Purch. Order Line No."))then exit;
        if PurchLine.Get(PurchLine."Document Type"::Order, SalesLine."Purchase Order No.", SalesLine."Purch. Order Line No.")then begin
            TestPurchLine(PurchLine, SalesLine);
            PurchLine."Sales Order No.":=SalesLine."Document No.";
            PurchLine."Sales Order Line No.":=SalesLine."Line No.";
            PurchLine."Purchasing Code":=SalesLine."Purchasing Code";
            PurchLine."Drop Shipment":=SalesLine."Drop Shipment";
            PurchLine.Modify(true);
        end;
    end;
    local procedure TestPurchLine(PurchLine: Record "Purchase Line"; SalesLine: Record "Sales Line")
    begin
        if PurchLine."Drop Shipment" then Error(StrSubstNo(Text50053, PurchLine."Document No.", PurchLine."Line No."));
        PurchLine.TestField("Quantity Received", 0);
        PurchLine.TestField(Type, PurchLine.Type::Item);
        PurchLine.TestField("No.", SalesLine."No.");
        PurchLine.TestField(Quantity, SalesLine.Quantity);
    end;
    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text)NewString: Text begin
        while StrPos(String, FindWhat) > 0 do String:=DelStr(String, StrPos(String, FindWhat)) + ReplaceWith + CopyStr(String, StrPos(String, FindWhat) + StrLen(FindWhat));
        NewString:=String;
    end;
    procedure CheckUsageRestriction(RecVar: Variant): Boolean var
        RecRef: RecordRef;
        RestrictedRecord: Record "Restricted Record";
    begin
        RecRef.GetTable(RecVar);
        if RecRef.IsTemporary then exit;
        RestrictedRecord.SetRange("Record ID", RecRef.RecordId);
        if not RestrictedRecord.FindFirst then exit(false);
        exit(true);
    end;
    #region JobDocumentClass
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnAfterTransferFromUnplannedDemand', '', false, false)]
    local procedure OnAfterTransferFromUnplannedDemand(var RequisitionLine: Record "Requisition Line"; UnplannedDemand: Record "Unplanned Demand")
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        if UnplannedDemand."Demand Type" = UnplannedDemand."Demand Type"::Job then begin
            JobPlanningLine.SetCurrentKey("Job Contract Entry No.");
            JobPlanningLine.SetRange("Job No.", UnplannedDemand."Demand Order No.");
            JobPlanningLine.SetRange("Job Contract Entry No.", UnplannedDemand."Demand Line No.");
            if JobPlanningLine.FindFirst()then begin
                RequisitionLine.Validate(Reserve, true);
                if JobPlanningLine."GSSSupply From" <> '' then begin
                    RequisitionLine.Validate("Supply From", JobPlanningLine."GSSSupply From");
                end;
                RequisitionLine.Validate("Direct Unit Cost", JobPlanningLine."Unit Cost");
                RequisitionLine.Validate("Unit Cost", JobPlanningLine."Unit Cost");
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Planning Line Management", 'OnAfterRecalculateWithOptionalModify', '', false, false)]
    local procedure OnAfterRecalculateWithOptionalModify(var RequisitionLine: Record "Requisition Line"; Direction: Option Forward, Backward)
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        JobPlanningLine.SetCurrentKey("Job Contract Entry No.");
        JobPlanningLine.SetRange("Job No.", RequisitionLine."Demand Order No.");
        JobPlanningLine.SetRange("Job Contract Entry No.", RequisitionLine."Demand Line No.");
        if JobPlanningLine.FindFirst()then begin
            RequisitionLine.Validate(Reserve, true);
            if JobPlanningLine."GSSSupply From" <> '' then begin
                RequisitionLine.Validate("Supply From", JobPlanningLine."GSSSupply From");
            end;
            RequisitionLine.Validate("Direct Unit Cost", JobPlanningLine."Unit Cost");
            RequisitionLine.Validate("Unit Cost", JobPlanningLine."Unit Cost");
            RequisitionLine.Modify();
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnBeforeGetDirectCost', '', false, false)]
    local procedure OnBeforeGetDirectCost(var ReqLine: Record "Requisition Line"; xReqLine: Record "Requisition Line"; CalledByFieldNo: Integer; FieldNo: Integer; Subcontracting: Boolean; var IsHandled: Boolean)
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        JobPlanningLine.SetCurrentKey("Job Contract Entry No.");
        JobPlanningLine.SetRange("Job No.", ReqLine."Demand Order No.");
        JobPlanningLine.SetRange("Job Contract Entry No.", ReqLine."Demand Line No.");
        if JobPlanningLine.FindFirst()then begin
            ReqLine.Validate("Direct Unit Cost", JobPlanningLine."Unit Cost");
            ReqLine.Validate("Unit Cost", JobPlanningLine."Unit Cost");
            IsHandled:=true;
        end;
    end;
    #endregion 
    #region CU-NotificationManagement
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure OnGetDocumentTypeAndNumber(VAR RecRef: RecordRef; VAR DocumentType: Text; VAR DocumentNo: Text; VAR IsHandled: Boolean)
    var
        FieldRef: FieldRef;
    begin
        case RecRef.Number of Database::Job: begin
            DocumentType:=RecRef.Caption;
            FieldRef:=RecRef.FIELD(1);
            DocumentNo:=FORMAT(FieldRef.VALUE);
            IsHandled:=true;
        end;
        end end;
    #endregion 
    #region Report-NotificatonEmail
    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnSetReportFieldPlaceholders', '', false, false)]
    local procedure OnSetReportFieldPlaceholders(RecRef: RecordRef; VAR Field1Label: Text; VAR Field1Value: Text; VAR Field2Label: Text; VAR Field2Value: Text)
    var
        JobRec: Record Job;
        AmountLbl: Label 'Total Budgeted Cost : %1, Total Budgeted Price: %2, Gross Margin: %3, Gross Margin % : %4%';
    begin
        case RecRef.Number of Database::Job: begin
            RecRef.SetTable(JobRec);
            Field1Label:='Customer';
            Field2Label:='Amount';
            Field1Value:=JobRec."Bill-to Name" + '/' + JobRec.Description;
            JobRec.CalcFields("GSSTotal Budgeted Cost", "GSSTotal Billable Price");
            Field2Value:=StrSubstNo(AmountLbl, JobRec."GSSTotal Budgeted Cost", JobRec."GSSTotal Billable Price", JobRec."GSSGross Margin", JobRec."GSSGross Margin %");
        end;
        end;
    end;
#endregion 
}
