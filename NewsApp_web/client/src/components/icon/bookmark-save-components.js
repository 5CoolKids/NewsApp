import React, { Component }  from 'react';
import { ToastContainer, toast, Zoom } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import './bookmark-save-styles.css';
import { SavedBookmark } from "./saved-bookmark-components";
import { NoSavedBookmark } from "./nosaved-bookmark-components";

class BookmarkSave extends Component {
    constructor() {
        super();
        this.state = {
            saved: false
        };
    } 

    handleSaving = () => {
        var oldItems = JSON.parse(localStorage.getItem('itemsArray')) || [];
        var newItem = this.props.news;
        oldItems.push(newItem);
        localStorage.setItem('itemsArray', JSON.stringify(oldItems));
        this.setState((prevState, prevProps) => {
            return { saved: !prevState.saved }
        });
        toast(`Saving ${this.props.news.title}`);
        console.log(JSON.parse(localStorage.getItem('itemsArray')));
    }

    handleRemoving = () => {
        var oldItems = JSON.parse(localStorage.getItem('itemsArray'));
        var updatedItems = [];
        for (var m in oldItems) {
            if (oldItems[m].web_url !== this.props.news.web_url) {
                updatedItems.push(oldItems[m]);
            }
        }
        localStorage.setItem('itemsArray', JSON.stringify(updatedItems));
        this.setState((prevState, prevProps) => {
            return { saved: !prevState.saved }
        });
        toast(`Removing ${this.props.news.title}`);
        console.log(JSON.parse(localStorage.getItem('itemsArray')));
    }

    componentDidMount() {
        var oldItems = JSON.parse(localStorage.getItem('itemsArray')) || [];
        for (var m in oldItems) {
            if (oldItems[m].web_url === this.props.news.web_url) {
                this.setState({ saved: true});
                break;
            }
        }
    }

    render() {
        return (
            <>
            {this.state.saved ? (
                <SavedBookmark onClick={() => {this.handleRemoving()}}/>
            ) : (
                <NoSavedBookmark onClick={() => {this.handleSaving()}} />
            )}
            <ToastContainer transition={Zoom} hideProgressBar={true} position={'top-center'} autoClose={3000}/>
            </>
        );
    }
}
export default BookmarkSave;