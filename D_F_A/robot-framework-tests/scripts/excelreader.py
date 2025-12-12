import pandas as pd

def return_portfolios(country):

    dataframe = pd.read_excel('robot-framework-tests/env/FundDocumentCenterTestingRules.xlsx', header = 1,
                                                        sheet_name = country)

    portfolios = []
    for index, row in dataframe.iterrows():
        portfolio_dict = dict()
        public_docs = [k for k in row.keys() if row[k]=='Yes']
        client_docs = [k for k in row.keys() if row[k] in ('Yes','Client')]
        portfolio_dict['portfolio_name'] = row['Portfolio Name']
        portfolio_dict['portfolio_id'] = row['Identifier']
        portfolio_dict['asset_class'] = row['Asset Class']
        portfolio_dict['public_docs'] = public_docs
        portfolio_dict['client_docs'] = client_docs
        portfolios.append(portfolio_dict)

    return portfolios


def get_portfolio_ids_for_endofquarter_validation(country, column_index):
    dataframe = pd.read_excel('robot-framework-tests/env/EndOfQuarterTesting.xlsx', header=None, sheet_name = country)

    portfolio_ids = dataframe.iloc[3:, 0]
    target_column = dataframe.iloc[3:, int(column_index)]
    final_portfolio_ids = portfolio_ids[target_column == 'Y']

    portfolios = final_portfolio_ids.tolist()
    return portfolios

def get_portfolio_ids_with_assetclass_for_endofquarter_validation(country, column_index):
    dataframe = pd.read_excel('robot-framework-tests/env/EndOfQuarterTesting.xlsx', header=None, sheet_name = country)
    result =  dataframe.apply(lambda row: (row[0], row[3]) if row[int(column_index)] == 'Y' else None, axis=1).dropna().tolist()
    return result

def get_portfolio_documents(country):
    dataframe = pd.read_excel('robot-framework-tests/env/LanguageVariantAssetIDFundDocuments.xlsx', header = 1, sheet_name = country)
    result = dataframe.groupby("Portfolio ID").apply(lambda x: {"Portfolio Name": x["Portfolio Name"].iloc[0], "Documents" : dict(zip(x["Document Type"], x["Asset ID"]))}).to_dict()
    return  result