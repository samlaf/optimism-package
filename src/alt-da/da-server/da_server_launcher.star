shared_utils = import_module(
    "github.com/ethpandaops/ethereum-package/src/shared_utils/shared_utils.star"
)
constants = import_module(
    "github.com/ethpandaops/ethereum-package/src/package_io/constants.star"
)

# Port IDs
DA_SERVER_HTTP_PORT_ID = "http"

# Port nums
DA_SERVER_HTTP_PORT_NUM = 3100


def get_used_ports():
    used_ports = {
        DA_SERVER_HTTP_PORT_ID: shared_utils.new_port_spec(
            DA_SERVER_HTTP_PORT_NUM,
            shared_utils.TCP_PROTOCOL,
            shared_utils.HTTP_APPLICATION_PROTOCOL,
        ),
    }
    return used_ports


def launch_da_server(
    plan,
    service_name,
    image,
    cmd,
    generic_commitment,
):
    config = get_da_server_config(
        plan,
        service_name,
        image,
        cmd,
        generic_commitment,
    )

    da_server_service = plan.add_service(service_name, config)

    http_url = "http://{0}:{1}".format(
        da_server_service.ip_address, DA_SERVER_HTTP_PORT_NUM
    )
    return new_da_server_context(
        http_url=http_url,
        generic_commitment=generic_commitment,
    )


def get_da_server_config(
    plan,
    service_name,
    image,
    cmd,
    generic_commitment,
):
    ports = get_used_ports()

    return ServiceConfig(
        image=image,
        ports=ports,
        cmd=cmd,
        private_ip_address_placeholder=constants.PRIVATE_IP_ADDRESS_PLACEHOLDER,
    )


def disabled_da_server_context():
    return new_da_server_context(
        http_url="",
        generic_commitment=True,
    )


def new_da_server_context(http_url, generic_commitment):
    return struct(
        enabled=http_url != "",
        http_url=http_url,
        generic_commitment=generic_commitment,
    )
