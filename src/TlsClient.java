import javax.net.ssl.*;
import java.net.Socket;
// import java.security.Provider;
// import java.security.Security;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
// import java.util.Enumeration;

public class TlsClient {
    public static void main(String[] args) throws Exception {
        System.setProperty("javax.net.debug", "ssl:handshake:verbose");
        /*
        try {
            Provider p[] = Security.getProviders();
            for (int i = 0; i < p.length; i++) {
                System.out.println(p[i]);
                for (Enumeration e = p[i].keys(); e.hasMoreElements();)
                    System.out.println("\t" + e.nextElement());
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        */
        SSLContext sslContext = SSLContext.getInstance("TLSv1.3");
        sslContext.init(null, new TrustManager[]{
            new X509TrustManager() {
                @Override
                public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                }

                @Override
                public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                }

                @Override
                public X509Certificate[] getAcceptedIssuers() {
                    return new X509Certificate[0];
                }
            }
        }, null);
        SSLSocketFactory ssf = sslContext.getSocketFactory();
        Socket s = ssf.createSocket("127.0.0.1", 9999);
        ((SSLSocket)s).getSession();
    }
}
