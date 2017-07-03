# HTTP to HTTPS proxy

A tiny web service for devices that cannot themselves handle HTTPS connections for some reason.

The service has a whitelist of HTTPS targets that it will accept to proxy to, and you use it by concatenating the target address with the address of this service.

For instance, if the service is running on `proxy.openmono.com` and you want to get a random number from

    https://www.random.org/integers/?num=1&min=1&max=10000000&col=5&base=10&format=plain

you can use the proxy thusly

    http://www.random.org.proxy.openmono.com/integers/?num=1&min=1&max=10000000&col=5&base=10&format=plain

To see the whitelist, use

    http://proxy.openmono.com/v1/whitelist
