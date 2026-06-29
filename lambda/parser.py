def parse_event(event):

    detail = event.get("detail", {})

    return {
        "event_name": detail.get("eventName", "Unknown"),
        "source_ip": detail.get("sourceIPAddress", "Unknown"),
        "region": detail.get("awsRegion", "Unknown"),
        "user": detail.get("userIdentity", {}).get("arn", "Unknown"),
        "event_time": detail.get("eventTime", "Unknown"),
        "service": detail.get("eventSource", "Unknown")
    }