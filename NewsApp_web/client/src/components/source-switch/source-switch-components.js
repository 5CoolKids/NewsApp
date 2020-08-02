import React, { Component }  from 'react';
import { withRouter } from "react-router-dom";
import Switch from "react-switch";
import './source-switch-styles.css';

class SourceSwitch extends Component {
    constructor() {
        super();
        this.state = { 
          show: true
        };
    }

    componentDidMount() {
        if (this.props.location.pathname === "/favorites" || this.props.location.pathname === "/article" || this.props.location.pathname === "/search") {
            this.setState({ show: false });
        }
    }

    componentDidUpdate(prevProps) {
        if ((this.props.location.pathname === "/favorites" || this.props.location.pathname === "/article" || this.props.location.pathname === "/search") 
            && prevProps.location.pathname !== this.props.location.pathname) {
            this.setState({ show: false });
        } else {
            if ((prevProps.location.pathname === "/favorites" || prevProps.location.pathname === "/article" || prevProps.location.pathname === "/search")
                && this.props.location.pathname !== prevProps.location.pathname) {
                this.setState({ show: true });
            }
        }
    }

    render() {
        const show = this.state.show;
        return (
            <>
            {show ? (
                <>
                <div className="sourceName">NYTimes</div>
                <Switch
                    onChange={this.props.handleSwitchChange}
                    checked={this.props.checked}
                    className="react-switch"
                    uncheckedIcon={false}
                    checkedIcon={false}
                    onColor="#08f"
                    offColor="#E0E0E0"
                />
                <div className="sourceName">Guardian</div>
                </>
            ) : (
                null
            )}
            </>
        );
    }
}
export default withRouter(SourceSwitch);


