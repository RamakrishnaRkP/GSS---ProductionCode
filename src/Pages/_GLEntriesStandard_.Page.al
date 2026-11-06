page 60108 "GLEntriesStandard"
{
    PageType = API;
    Caption = 'GLEntries';
    APIPublisher = 'GSS';
    APIGroup = 'Standard';
    APIVersion = 'v1.0';
    EntityName = 'GLEntriesStandard';
    EntitySetName = 'GLEntriesStandard';
    SourceTable = "G/L Entry";
    SourceTableView = where("Job No."=filter(<>''));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GLEntries)
            {
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Revenue; BillablePrice)
                {
                    ApplicationArea = All;
                }
                field(Cost; BudgetedCost)
                {
                    ApplicationArea = All;
                }
                field(InternalCost; InternalCost)
                {
                    ApplicationArea = All;
                }
                field(GP; BillablePrice - BudgetedCost + InternalCost)
                {
                    ApplicationArea = All;
                }
                field(Job_No; Rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field(Dim1Name; DimensionValue)
                {
                    ApplicationArea = All;
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = All;
                }
                field(InvoiceNo; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(CompanyName; CompanyName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        Clear(DimensionValue);
        DimValueRec.Reset();
        DimValueRec.SetRange("Global Dimension No.", 1);
        DimValueRec.SetRange(Code, Rec."Global Dimension 1 Code");
        if DimValueRec.FindFirst()then DimensionValue:=DimValueRec.Name
        else
            DimensionValue:='';
        Clear(InternalCost);
        Clear(BillablePrice);
        Clear(BudgetedCost);
        Clear(GrossProfit);
        Clear(GrossProfitWoInternalCost);
        Clear(CustomerName);
        if SalInvHdr.Get(Rec."Document No.")then CustomerName:=SalInvHdr."Sell-to Customer Name";
        if AccountExists(RevenueAccs, Rec."G/L Account No.")then BillablePrice:=Rec.Amount * -1;
        if AccountExists(InternalCostAccs, Rec."G/L Account No.")then InternalCost:=Rec.Amount;
        if AccountExists(CostOfSalesAccs, Rec."G/L Account No.")then BudgetedCost:=Rec.Amount;
        if(BillablePrice = 0) and (BudgetedCost = 0)then exit;
    end;
    trigger OnInit()
    begin
        Clear(GLFilterText);
        InvAccSchedule:='JOBINVREP';
        if AccSchedule.Get(InvAccSchedule)then begin
            AccScheduleLines.SetCurrentKey("Schedule Name", "Line No.");
            AccScheduleLines.SetRange("Schedule Name", AccSchedule.Name);
            AccScheduleLines.SetRange(Description, 'Revenue');
            if AccScheduleLines.FindFirst()then RevenueAccStart:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Revenue Total');
            if AccScheduleLines.FindFirst()then RevenueAccEnd:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Cost of Sales');
            if AccScheduleLines.FindFirst()then CostOfSalesAccStart:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Cost of Sales Total');
            if AccScheduleLines.FindFirst()then CostOfSalesAccEnd:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Internal Cost');
            if AccScheduleLines.FindFirst()then InternalCostAccStart:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Internal Cost Total');
            if AccScheduleLines.FindFirst()then InternalCostAccEnd:=AccScheduleLines."Row No.";
            I:=1;
            AccScheduleLines.SetRange(Description);
            AccScheduleLines.SetRange("Row No.", RevenueAccStart, RevenueAccEnd);
            AccScheduleLines.SetFilter(Totaling, '<>%1', '');
            if AccScheduleLines.FindFirst()then repeat RevenueAccs[I]:=AccScheduleLines.Totaling;
                    if GLFilterText = '' then GLFilterText:=AccScheduleLines.Totaling
                    else
                    begin
                        GLFilterText+='|' + AccScheduleLines.Totaling;
                    end;
                    I+=1;
                until AccScheduleLines.Next() = 0;
            I:=1;
            AccScheduleLines.SetRange(Description);
            AccScheduleLines.SetRange("Row No.", CostOfSalesAccStart, CostOfSalesAccEnd);
            AccScheduleLines.SetFilter(Totaling, '<>%1', '');
            if AccScheduleLines.FindFirst()then repeat CostOfSalesAccs[I]:=AccScheduleLines.Totaling;
                    if GLFilterText = '' then GLFilterText:=AccScheduleLines.Totaling
                    else
                    begin
                        GLFilterText+='|' + AccScheduleLines.Totaling;
                    end;
                    I+=1;
                until AccScheduleLines.Next() = 0;
            I:=1;
            AccScheduleLines.SetRange(Description);
            AccScheduleLines.SetRange("Row No.", InternalCostAccStart, InternalCostAccEnd);
            AccScheduleLines.SetFilter(Totaling, '<>%1', '');
            if AccScheduleLines.FindFirst()then repeat InternalCostAccs[I]:=AccScheduleLines.Totaling;
                    if GLFilterText = '' then GLFilterText:=AccScheduleLines.Totaling
                    else
                    begin
                        GLFilterText+='|' + AccScheduleLines.Totaling;
                    end;
                    I+=1;
                until AccScheduleLines.Next() = 0;
        end;
        Rec.SetFilter("G/L Account No.", GLFilterText);
    end;
    local procedure AccountExists(Arr: Array[50]of code[20]; AccNo: Code[20]): Boolean var
        Exists: Boolean;
    begin
        Exists:=false;
        if ArrayLen(Arr) = 0 then exit(Exists);
        for I:=1 to ArrayLen(Arr)do begin
            if Arr[I] = AccNo then begin
                Exists:=true;
                break;
            end;
        end;
        Exit(Exists);
    end;
    var I: Integer;
    InvAccSchedule: Code[20];
    AccSchedule: Record "Acc. Schedule Name";
    AccScheduleLines: Record "Acc. Schedule Line";
    RevenueAccs: array[50]of Code[20];
    CostOfSalesAccs: array[50]of Code[20];
    InternalCostAccs: array[50]of Code[20];
    RevenueAccStart: Text;
    RevenueAccEnd: Text;
    CostOfSalesAccStart: Text;
    CostOfSalesAccEnd: Text;
    InternalCostAccStart: Text;
    InternalCostAccEnd: Text;
    PlannedDeliveryMonth: Text;
    SalesPersonRec: Record "Salesperson/Purchaser";
    FilterText: Text;
    CompInfo: Record "Company Information";
    HideTotals: Boolean;
    HideHeader: Boolean;
    GroupByLOB: Boolean;
    BillablePrice: Decimal;
    BudgetedCost: Decimal;
    InternalCost: Decimal;
    GrossProfit: Decimal;
    GrossProfitWoInternalCost: Decimal;
    GLFilterText: Text;
    CustomerName: Text[100];
    SalInvHdr: Record "Sales Invoice Header";
    DimValueRec: Record "Dimension Value";
    DimensionValue: Text[50];
}
