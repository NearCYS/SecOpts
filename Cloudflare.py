import cloudflare
import argparse

class ClouflareConfs():

    def ConfigApi(Api, token, data, campus):
        japi = Api
        #campus me refiero a que puede ser utilizado para la configuracion dns, entre otras consultas
        #send.requets(api=japi, data, campus)
    def ConnectionCloud(token):
        


    def PrintReturned():
        print('Opcion t')
        return 0

    

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Manual de configuracion dns CLoudflare")
    parser.add_argument("-t", "--token", help="token de la cuenta de cloudflare")
    args =  parser.parse_args()
    if args.token:
       PrintReturned()
