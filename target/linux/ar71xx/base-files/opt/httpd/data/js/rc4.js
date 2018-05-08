function Rc4B64Class() {

var sbox = new Array(256);
var key = new Array(256);
var keyStr = "ABCDEFGHIJKLMNOP" +
                "QRSTUVWXYZabcdef" +
                "ghijklmnopqrstuv" +
                "wxyz0123456789+/" +
                "=";

this.Encrypt = _RC4Enc;
this.Decrypt = _RC4Dec;

function _RC4Enc(strTexto,strClave){
	return encode64(_RC4(strTexto,strClave))
}

function _RC4Dec(strTexto,strClave){
	return _RC4(decode64(strTexto),strClave)
}

function InicializarRC4(strLlave) {
	// Contadores
	var a, b, tempSwap;

	// Initialize key[] and sbox[]
	// key[]: With the Unicode values of the key until 256.
	// sbox[]: With numbers 1 - 255.
	for (a = 0; a < 256; a++) {
		key[a] = (strLlave.charCodeAt(a % strLlave.length)) % 256;
		sbox[a] = a;
	}

	// Re-order the array sbox[] from the private key.
	// Iterating each element of sbox[] re-calculate the counter 'b'
	// Then we do the swap
	// This is, interchange the element in sbox[a] by sbox[b]
	b = 0;
	for (a = 0; a < 256; a++) {
		b = (b + sbox[a] + key[a]) % 256;
		tempSwap = sbox[a];
		sbox[a] = sbox[b];
		sbox[b] = tempSwap;
	}
	// This gives a new order to elements in sbox[]
	// This is a permutation calculated from the private key.
}

function _RC4(strTexto,strClave) {
	// Variables
	var a, i, j, k, temp, cipherby, cipher;

	i = 0;
	j = 0;
	cipher = "";
	temp = 0;

	// Inicialize key
	InicializarRC4(strClave);

	// Cipher stage:
	// For each byte of the message (from a = 0 until a = message length)
	// We calculate the variables i, j.
	// Then we swap sbox[i] and sbox[j]
	// Finally, we calculate the variable cipherby and the byte is ciphered.
	for (a = 0; a < strTexto.length; a++) {
		i = (i + 1) % 256;
		j = (j + sbox[i]) % 256;
		temp = sbox[i];
		sbox[i] = sbox[j];
		sbox[j] = temp;

		k = sbox[(sbox[i] + sbox[j]) % 256];

		cipherby = strTexto.charCodeAt(a) ^ k;
		cipher = cipher + String.fromCharCode(cipherby);
	}
	return(cipher);
}
   function encode64(input) {
      var output = "";
      var chr1, chr2, chr3 = "";
      var enc1, enc2, enc3, enc4 = "";
      var i = 0;

      do {
         chr1 = input.charCodeAt(i++);
         chr2 = input.charCodeAt(i++);
         chr3 = input.charCodeAt(i++);

         enc1 = chr1 >> 2;
         enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
         enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
         enc4 = chr3 & 63;

         if (isNaN(chr2)) {
            enc3 = enc4 = 64;
         } else if (isNaN(chr3)) {
            enc4 = 64;
         }

         output = output +
            keyStr.charAt(enc1) +
            keyStr.charAt(enc2) +
            keyStr.charAt(enc3) +
            keyStr.charAt(enc4);
         chr1 = chr2 = chr3 = "";
         enc1 = enc2 = enc3 = enc4 = "";
      } while (i < input.length);

      return output;
   }

   function decode64(input) {
      var output = "";
      var chr1, chr2, chr3 = "";
      var enc1, enc2, enc3, enc4 = "";
      var i = 0;

      // remove all characters that are not A-Z, a-z, 0-9, +, /, or =
      var base64test = /[^A-Za-z0-9\+\/\=]/g;
      if (base64test.exec(input)) {
         Response.write("There were invalid base64 characters in the input text.\n" +
               "Valid base64 characters are A-Z, a-z, 0-9, '+', '/', and '='\n" +
               "Expect errors in decoding.");
      }
      input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

      do {
         enc1 = keyStr.indexOf(input.charAt(i++));
         enc2 = keyStr.indexOf(input.charAt(i++));
         enc3 = keyStr.indexOf(input.charAt(i++));
         enc4 = keyStr.indexOf(input.charAt(i++));

         chr1 = (enc1 << 2) | (enc2 >> 4);
         chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
         chr3 = ((enc3 & 3) << 6) | enc4;

         output = output + String.fromCharCode(chr1);

         if (enc3 != 64) {
            output = output + String.fromCharCode(chr2);
         }
         if (enc4 != 64) {
            output = output + String.fromCharCode(chr3);
         }

         chr1 = chr2 = chr3 = "";
         enc1 = enc2 = enc3 = enc4 = "";

      } while (i < input.length);

      return output;
   }

}

function rc4_encrypt(key, text)
{
	if( text == "" || text == undefined)
		return -1;
	var output =  (new Rc4B64Class()).Encrypt(text,key);
	return output;
}

function rc4_decrypt(key, text)
{
	if( text == "" || text == undefined)
		return -1;
	var output =  (new Rc4B64Class()).Decrypt(text,key);
	return output;
}
