public class XeroXmlUtility {

    public static Boolean includeNullValues = false;

    public static Boolean includeXmlLine = false;

    public static String serialize(Object objectToSerialize, String parentNode) {

        String jsonString = JSON.serialize(objectToSerialize);
        JSONParser parser = JSON.createParser(jsonString);
        Dom.Document xmlDoc = new Dom.Document();
        Dom.XmlNode parentElement = xmlDoc.createRootElement(parentNode, null, null);
        processJson (parser, parentElement);
        String xmlString = xmlDoc.toXmlString();
        String NewString=   xmlString .substring(0, xmlString .indexOf('<Address>')) +
                            '<Addresses>'+
                             xmlString.substring(xmlString .indexOf('<Address>'), xmlString.indexOf('</Address>')+10)+
                             '</Addresses>'+
                             xmlString.substring(xmlString .indexOf('</Address>')+10, xmlString.length());
         
         system.debug('NewString==========='+NewString);
        system.debug('xmlString  outside=========='+xmlString );
        if (!includeXmlLine) {
            NewString= NewString.replace('<?xml version="1.0" encoding="UTF-8"?>','');
            system.debug('xmlString ======'+xmlString );
            
        }

        return NewString;
    }

    private static void processJson (JSONParser parser, Dom.XmlNode parentElement) {

        while (parser.nextToken() != null) {

            if (parser.getCurrentToken() == JSONToken.START_OBJECT && parser.getCurrentName() != null) {

                processJsonObject (parser, parentElement, parser.getCurrentName());
            }

            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

                processJsonArray (parser, parentElement);
            }

            if (acceptedValues.contains(String.valueOf(parser.getCurrentToken()))) {

                addValueElement (parser, parentElement);
            }
        }

    }

    private static void processJsonObject (JSONParser parser, Dom.XmlNode parentElement, String objectName) {

        Dom.XmlNode objectElement = parentElement.addChildElement(removeX(objectName), null, null);

        while (parser.nextToken() != null) {

            if (parser.getCurrentToken() == JSONToken.END_OBJECT) {

                break;
            }

            if (parser.getCurrentToken() == JSONToken.START_OBJECT && parser.getCurrentName() != null) {

                processJsonObject (parser, parentElement, parser.getCurrentName());
            }

            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

                processJsonArray (parser, parentElement);
            }

            if (acceptedValues.contains(String.valueOf(parser.getCurrentToken()))) {

                addValueElement (parser, objectElement);
            }
        }
    }

    private static void processJsonArray (JSONParser parser, Dom.XmlNode parentElement) {

        Boolean topLevelArray = false;

        String parentArrayName = parser.getCurrentName();

        if (String.isBlank(parentArrayName)) {

            parentArrayName = parentElement.getName().substring(0, parentElement.getName().length() - 1);

            topLevelArray = true;
        }

        Dom.XmlNode arrayElement = parentElement.addChildElement(removeX(parentArrayName), null, null);

        while (parser.nextToken() != null) {

            if (parser.getCurrentToken() == JSONToken.END_ARRAY) {

                break;
            }

            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {

                if (!topLevelArray) {

                    String arrayName = parser.getCurrentName();

                    if (String.isBlank(arrayName)) {

                        arrayName = arrayElement.getName();

                        arrayName = arrayName.substring(0, arrayName.length() - 1);
                    }

                    processJsonObject (parser, arrayElement, arrayName);
                }
            }

            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

                processJsonArray (parser, parentElement);
            }

            if (acceptedValues.contains(String.valueOf(parser.getCurrentToken()))) {

                addValueElement (parser, arrayElement);
            }

            topLevelArray = false;
        }
    }

    
    private static void addValueElement (JSONParser parser, Dom.XmlNode parentElement) {

        Dom.XmlNode childElement = parentElement.addChildElement(removeX(parser.getCurrentName()), null, null);

        childElement.addTextNode(parser.getText());
      
       
    }

    private static String removeX(String value) {

        if (String.isNotBlank(value)) {

            return value.replace('_x','');
        }
        else {

            return value;
        }
    }

    private static Set<String> acceptedValues {

        get {
            acceptedValues = new Set<String>{
                'VALUE_FALSE',
                'VALUE_NUMBER_FLOAT',
                'VALUE_NUMBER_INT',
                'VALUE_STRING',
                'VALUE_TRUE'
            };

            if (includeNullValues) {
                acceptedValues.add('VALUE_NULL');
            }

            return acceptedValues;
        }
        set;
    }

}