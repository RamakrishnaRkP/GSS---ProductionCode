page 60104 "CustomerAging"
{
    PageType = API;
    Caption = 'CustomerAging';
    APIPublisher = 'GSS';
    APIGroup = 'CustomerAging';
    APIVersion = 'v1.0';
    EntityName = 'CustomerAging';
    EntitySetName = 'CustomerAging';
    SourceTable = Customer;
    SourceTableView = where("GSS Dispute"=const(false), "Customer Posting Group"=const('DEBTORS'));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Customer)
            {
                field(Customer_No; Rec."No.")
                {
                }
                field(Customer_Name; Rec.Name)
                {
                }
                field(Outstanding; CustBalanceDueLCY[7] + CustBalanceDueLCY[6] + CustBalanceDueLCY[5] + CustBalanceDueLCY[4] + CustBalanceDueLCY[3] + CustBalanceDueLCY[2] + CustBalanceDueLCY[1] + UnadjustedCredit)
                {
                }
                field(NotDueAmount; CustBalanceDueLCY[7])
                {
                }
                field(OverDueAmount; CustBalanceDueLCY[6] + CustBalanceDueLCY[5] + CustBalanceDueLCY[4] + CustBalanceDueLCY[3] + CustBalanceDueLCY[2] + CustBalanceDueLCY[1] + UnadjustedCredit)
                {
                }
                field(Bucket1Amount; CustBalanceDueLCY[6])
                {
                }
                field(Bucket2Amount; CustBalanceDueLCY[5])
                {
                    AutoFormatType = 1;
                }
                field(Bucket3Amount; CustBalanceDueLCY[4])
                {
                    AutoFormatType = 1;
                }
                field(Bucket4Amount; CustBalanceDueLCY[3])
                {
                    AutoFormatType = 1;
                }
                field(Bucket5Amount; CustBalanceDueLCY[2])
                {
                    AutoFormatType = 1;
                }
                field(Bucket6Amount; CustBalanceDueLCY[1])
                {
                    AutoFormatType = 1;
                }
                field(UnadjustedCreditAmount; UnadjustedCredit)
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord();
    begin
        PrintCust:=false;
        UnadjustedCredit:=0;
        for i:=1 to 7 do begin
            DtldCustLedgEntry.SETCURRENTKEY("Customer No.", "Initial Entry Due Date", "Posting Date");
            DtldCustLedgEntry.SETRANGE("Customer No.", Rec."No.");
            DtldCustLedgEntry.SETRANGE("Posting Date", 0D, StartDate);
            if Type = Type::"Due Date" then DtldCustLedgEntry.SETRANGE("Initial Entry Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            if Type = Type::"Posting Date" then DtldCustLedgEntry.SETRANGE("Posting Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            DtldCustLedgEntry.CALCSUMS("Amount (LCY)");
            CustBalanceDueLCY[i]:=DtldCustLedgEntry."Amount (LCY)";
            //Unadjusted Credit
            CLEAR(CustLedgEntry);
            CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
            CustLedgEntry.SETRANGE("Customer No.", Rec."No.");
            CustLedgEntry.SETRANGE(Open, true);
            CustLedgEntry.SETRANGE(Positive, false);
            if Type = Type::"Due Date" then CustLedgEntry.SETRANGE("Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            if Type = Type::"Posting Date" then CustLedgEntry.SETRANGE("Posting Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
            CustLedgEntry.SETRANGE("Posting Date", 0D, StartDate);
            //CustLedgEntry.CALCSUMS("Amount (LCY)");
            if CustLedgEntry.FINDFIRST then repeat CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                    CustBalanceDueLCY[i]-=CustLedgEntry."Remaining Amt. (LCY)";
                    UnadjustedCredit+=CustLedgEntry."Remaining Amt. (LCY)";
                until CustLedgEntry.NEXT = 0;
            //Unadjusted Credit
            if CustBalanceDueLCY[i] <> 0 then PrintCust:=true;
            if UnadjustedCredit <> 0 then PrintCust:=true;
        end;
    end;
    trigger OnInit()
    begin
        StartDate:=WORKDATE;
        Type:=type::"Due Date";
        PerInt[5]:=30;
        PerInt[4]:=60;
        PerInt[3]:=90;
        PerInt[2]:=180;
        PerInt[1]:=365;
        PeriodStartDate[7]:=StartDate;
        PeriodStartDate[8]:=99991231D;
        j:=1;
        for i:=6 downto 2 do begin
            j+=1;
            PeriodStartDate[i]:=CALCDATE(STRSUBSTNO('<-%1>', FORMAT(PerInt[i - 1]) + 'D'), PeriodStartDate[7]);
            if i - 2 <> 0 then CustBalLabelCaption[i - 1]:=STRSUBSTNO(CustBalLabel, PerInt[i - 1] + 1, (PerInt[i - 2]));
        end;
        ;
    end;
    var Text001: Label 'As of %1';
    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    StartDate: Date;
    CustFilter: Text;
    PeriodStartDate: array[8]of Date;
    CustBalanceDueLCY: array[7]of Decimal;
    PrintCust: Boolean;
    i: Integer;
    Customer___Summary_Aging_Simp_CaptionLbl: Label 'Customer - Summary Aging';
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
    CustLedgEntry: Record "Cust. Ledger Entry";
    UnadjustedCredit: Decimal;
    j: Integer;
    CustBalLabelCaption: array[7]of Text;
    PeriodInt: Integer;
    CustBalLabel: Label '%1-%2 Days';
    PerInt: array[5]of Integer;
    Type: Option "Posting Date", "Due Date";
}
