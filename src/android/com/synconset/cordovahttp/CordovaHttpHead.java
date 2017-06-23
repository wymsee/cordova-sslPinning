/**
 * A HTTP plugin for Cordova / Phonegap
 */
package com.synconset.cordovahttp;

import java.net.UnknownHostException;

import javax.net.ssl.SSLHandshakeException;

import org.apache.cordova.CallbackContext;
import org.json.JSONException;
import org.json.JSONObject;

import com.github.kevinsawicki.http.HttpRequest;
import com.github.kevinsawicki.http.HttpRequest.HttpRequestException;

class CordovaHttpHead extends CordovaHttp implements Runnable {
    public CordovaHttpHead(String urlString, JSONObject params, JSONObject headers, CallbackContext callbackContext) {
        super(urlString, params, headers, callbackContext);
    }

    @Override
    public void run() {
        try {
            HttpRequest request = HttpRequest.head(this.getUrlString(), this.getParamsMap(), true);

            this.setupSecurity(request);
            request.acceptCharset(CHARSET);
            request.headers(this.getHeadersMap());

            int code = request.code();
            JSONObject response = new JSONObject();

            this.addResponseHeaders(request, response);
            response.put("status", code);

            if (code >= 200 && code < 300) {
                // no 'body' to return for HEAD request
                this.getCallbackContext().success(response);
            } else {
                String body = request.body(CHARSET);
                response.put("error", body);
                this.getCallbackContext().error(response);
            }
        } catch (JSONException e) {
            this.respondWithError("There was an error generating the response");
        } catch (HttpRequestException e) {
            if (e.getCause() instanceof UnknownHostException) {
                this.respondWithError(0, "The host could not be resolved");
            } else if (e.getCause() instanceof SSLHandshakeException) {
                this.respondWithError("SSL handshake failed");
            } else {
                this.respondWithError("There was an error with the request");
            }
        }
    }
}
