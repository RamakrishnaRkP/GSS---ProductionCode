reportextension 60104 MyExtension extends "Standard Sales - Credit Memo"
{
    dataset
    {
        add(Header)
        {
            column(DocumentTitle_Lbl2; SalesCreditMemoLbl2)
            {
            }
            column(CustVat;'VAT No.' + GetCustomerVATRegistrationNumber)
            {
            }
        }
    }
    var SalesCreditMemoLbl2: Label 'Tax Credit Note';
}
