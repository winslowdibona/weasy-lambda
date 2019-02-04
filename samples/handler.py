def handler(event, context):
    try:
        import weasyprint
        print(weasyprint.__version__)
        return weasyprint.__version__
    except Exception as e:
        print(e)
        return 'Oops'
