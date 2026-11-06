report 60102 "GSSVendor Aging - Detailed"
{
    // version GSS-ASH
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/Vendor Aging - Detailed.rdl';
    Caption = ' Vendor - Detailed Aging';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.", "Search Name", "Vendor Posting Group", "Statistics Group", "Payment Terms Code";

            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No."=FIELD("No.");

                column(STRSUBSTNO_Text001_FORMAT_StartDate__; STRSUBSTNO(Text001, FORMAT(StartDate)))
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(COMPANYNAME; COMPANYNAME)
                {
                }
                column(Customer_TABLECAPTION__________CustFilter; TABLECAPTION + ': ' + CustFilter)
                {
                }
                column(CustFilter; CustFilter)
                {
                }
                column(CustBalanceDueLCY_7_; CustBalanceDueLCY[7])
                {
                }
                column(CustBalanceDueLCY_6_; CustBalanceDueLCY[6])
                {
                }
                column(CustBalanceDueLCY_5_; CustBalanceDueLCY[5])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_4_; CustBalanceDueLCY[4])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_3_; CustBalanceDueLCY[3])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_2_; CustBalanceDueLCY[2])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_1_; CustBalanceDueLCY[1])
                {
                AutoFormatType = 1;
                }
                column(UnadjustedCredit; UnadjustedCredit)
                {
                }
                column(Customer__No__; "Vendor No.")
                {
                }
                column(Customer_Name; Vendor.Name)
                {
                }
                column(DocNo; "Vendor Ledger Entry"."Document No.")
                {
                }
                column(PostingDate; "Vendor Ledger Entry"."Posting Date")
                {
                }
                column(Amount; "Vendor Ledger Entry"."Amount (LCY)")
                {
                }
                column(CustBalanceDueLCY_5__Control25; CustBalanceDueLCY[5])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_4__Control26; CustBalanceDueLCY[4])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_3__Control27; CustBalanceDueLCY[3])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_2__Control28; CustBalanceDueLCY[2])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_1__Control29; CustBalanceDueLCY[1])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_5__Control37; CustBalanceDueLCY[5])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_4__Control38; CustBalanceDueLCY[4])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_3__Control39; CustBalanceDueLCY[3])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_2__Control40; CustBalanceDueLCY[2])
                {
                AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_1__Control41; CustBalanceDueLCY[1])
                {
                AutoFormatType = 1;
                }
                column(Customer___Summary_Aging_Simp_Caption; Customer___Summary_Aging_Simp_CaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
                {
                }
                column(Customer__No__Caption; FIELDCAPTION("Vendor No."))
                {
                }
                column(Customer_NameCaption; Vendor.FIELDCAPTION(Name))
                {
                }
                column(CustBalanceDueLCY_7__Control51Caption; CustBalanceDueLCY_7__Control51CaptionLbl)
                {
                }
                column(CustBalanceDueLCY_6__Control52Caption; CustBalanceDueLCY_6__Control52CaptionLbl)
                {
                }
                column(CustBalanceDueLCY_5__Control25Caption; CustBalanceDueLCY_5__Control25CaptionLbl)
                {
                }
                column(CustBalanceDueLCY_4__Control26Caption; CustBalanceDueLCY_4__Control26CaptionLbl)
                {
                }
                column(CustBalanceDueLCY_3__Control27Caption; CustBalanceDueLCY_3__Control27CaptionLbl)
                {
                }
                column(CustBalanceDueLCY_2__Control28Caption; CustBalanceDueLCY_2__Control28CaptionLbl)
                {
                }
                column(CustBalanceDueLCY_1__Control29Caption; CustBalanceDueLCY_1__Control29CaptionLbl)
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                trigger OnAfterGetRecord();
                begin
                    CLEAR(CustBalanceDueLCY);
                    PrintCust:=false;
                    UnadjustedCredit:=0;
                    for i:=1 to 7 do begin
                        DtldCustLedgEntry.SETCURRENTKEY("Vendor No.", "Initial Entry Due Date", "Posting Date");
                        //DtldCustLedgEntry.SETRANGE("Customer No.","Customer No.");
                        DtldCustLedgEntry.SETRANGE("Posting Date", 0D, StartDate);
                        DtldCustLedgEntry.SETRANGE("Initial Entry Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                        DtldCustLedgEntry.SETRANGE("Vendor Ledger Entry No.", "Entry No.");
                        DtldCustLedgEntry.CALCSUMS("Amount (LCY)");
                        CustBalanceDueLCY[i]:=DtldCustLedgEntry."Amount (LCY)";
                        //Unadjusted Credit
                        /*
                        CLEAR(CustLedgEntry);
                        CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
                        CustLedgEntry.SETRANGE("Customer No.","Customer No.");
                        CustLedgEntry.SETRANGE(Open,TRUE);
                        CustLedgEntry.SETRANGE(Positive,FALSE);
                        CustLedgEntry.SETRANGE("Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                        CustLedgEntry.SETRANGE("Posting Date",0D,StartDate);
                        //CustLedgEntry.CALCSUMS("Amount (LCY)");
                        IF CustLedgEntry.FINDFIRST THEN REPEAT
                        */
                        if("Due Date" >= PeriodStartDate[i]) and ("Due Date" <= PeriodStartDate[i + 1] - 1)then if Positive then begin
                                CALCFIELDS("Remaining Amt. (LCY)");
                                CustBalanceDueLCY[i]-="Remaining Amt. (LCY)";
                                UnadjustedCredit+="Remaining Amt. (LCY)";
                            end;
                        //UNTIL CustLedgEntry.NEXT = 0;
                        //Unadjusted Credit
                        if CustBalanceDueLCY[i] <> 0 then PrintCust:=true;
                        if UnadjustedCredit <> 0 then PrintCust:=true;
                    end;
                    if not PrintCust then CurrReport.SKIP;
                end;
                trigger OnPreDataItem();
                begin
                    SETRANGE("Posting Date", 0D, StartDate);
                end;
            }
            trigger OnAfterGetRecord();
            begin
            /*
                PrintCust := FALSE;
                UnadjustedCredit := 0;
                FOR i := 1 TO 7 DO BEGIN
                  DtldCustLedgEntry.SETCURRENTKEY("Customer No.","Initial Entry Due Date","Posting Date");
                  DtldCustLedgEntry.SETRANGE("Customer No.","No.");
                  DtldCustLedgEntry.SETRANGE("Posting Date",0D,StartDate);
                  DtldCustLedgEntry.SETRANGE("Initial Entry Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                  DtldCustLedgEntry.CALCSUMS("Amount (LCY)");
                  CustBalanceDueLCY[i] := DtldCustLedgEntry."Amount (LCY)";
                
                  //Unadjusted Credit
                  CLEAR(CustLedgEntry);
                  CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
                  CustLedgEntry.SETRANGE("Customer No.","No.");
                  CustLedgEntry.SETRANGE(Open,TRUE);
                  CustLedgEntry.SETRANGE(Positive,FALSE);
                  CustLedgEntry.SETRANGE("Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                  CustLedgEntry.SETRANGE("Posting Date",0D,StartDate);
                  //CustLedgEntry.CALCSUMS("Amount (LCY)");
                  IF CustLedgEntry.FINDFIRST THEN REPEAT
                    CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                    CustBalanceDueLCY[i] -= CustLedgEntry."Remaining Amt. (LCY)";
                    UnadjustedCredit -= CustLedgEntry."Remaining Amt. (LCY)";
                  UNTIL CustLedgEntry.NEXT = 0;
                  //Unadjusted Credit
                
                  IF CustBalanceDueLCY[i] <> 0 THEN
                    PrintCust := TRUE;
                END;
                IF NOT PrintCust THEN
                  CurrReport.SKIP;
                */
            end;
            trigger OnPreDataItem();
            begin
                CurrReport.CREATETOTALS(CustBalanceDueLCY);
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(StartingDate; StartDate)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage();
        begin
            if StartDate = 0D then StartDate:=WORKDATE;
        end;
    }
    labels
    {
    }
    trigger OnPreReport();
    begin
        CustFilter:=Vendor.GETFILTERS;
        //PeriodStartDate[5] := StartDate;
        //PeriodStartDate[6] := 31129999D;
        PeriodStartDate[7]:=StartDate;
        PeriodStartDate[8]:=99991231D;
        for i:=6 downto 2 do PeriodStartDate[i]:=CALCDATE('<-30D>', PeriodStartDate[i + 1]);
    end;
    var Text001: Label 'As of %1';
    DtldCustLedgEntry: Record "Detailed Vendor Ledg. Entry";
    StartDate: Date;
    CustFilter: Text;
    PeriodStartDate: array[8]of Date;
    CustBalanceDueLCY: array[7]of Decimal;
    PrintCust: Boolean;
    i: Integer;
    Customer___Summary_Aging_Simp_CaptionLbl: Label '"Vendor - Detailed Aging "';
    CurrReport_PAGENOCaptionLbl: Label 'Page';
    All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
    CustBalanceDueLCY_7__Control51CaptionLbl: Label 'Not Due';
    CustBalanceDueLCY_6__Control52CaptionLbl: Label '0-30 days';
    CustBalanceDueLCY_5__Control25CaptionLbl: Label '31-60 days';
    CustBalanceDueLCY_4__Control26CaptionLbl: Label '61-90 days';
    CustBalanceDueLCY_3__Control27CaptionLbl: Label '91-120 days';
    CustBalanceDueLCY_2__Control28CaptionLbl: Label '121-150 days';
    CustBalanceDueLCY_1__Control29CaptionLbl: Label 'Over 151 days';
    TotalCaptionLbl: Label 'Total';
    CustLedgEntry: Record "Vendor Ledger Entry";
    UnadjustedCredit: Decimal;
    procedure InitializeRequest(StartingDate: Date);
    begin
        StartDate:=StartingDate;
    end;
}
