tableextension 60131 "GSSFinance Cue" extends "Finance Cue"
{
    fields
    {
        field(60100; "GSSUpcoming Invoices"; Integer)
        {
            CalcFormula = Count(Job WHERE(Status=FILTER(Planning|Quote|Open), "Next Invoice Date"=FIELD("GSSDate Filter")));
            Caption = 'Upcoming Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60101; "GSSInvoices Due - Not Created"; Integer)
        {
            CalcFormula = Count(Job WHERE(Status=CONST(Open), "Next Invoice Date"=FIELD("GSSDate Filter2")));
            Caption = 'Invoices Due - Not Created';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60150; "GSSDate Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(60151; "GSSDate Filter2"; Date)
        {
            Caption = 'Date Filter2';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }
}
